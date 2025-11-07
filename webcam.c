#include <math.h>
#include <stdio.h>
#include <fcntl.h>
#include <errno.h>
#include <raylib.h>
#include <unistd.h>
#include <stdbool.h>
#include <sys/mman.h>
#include <sys/ioctl.h>
#include <linux/videodev2.h>

#define WIDTH 800
#define HEIGHT 600

static int xioctl(int fd, int request, void *arg)
{
    int r;

    do {
        r = ioctl(fd, request, arg);
    } while (r == -1 && errno == EINTR);

    return r;
}

int main(int argc, char** argv) {
    char *device = "/dev/video0";
    
    // Open the device
    int fd = open(device, O_RDWR);

    if (fd == -1) {
        fprintf(stderr, "ERROR: Could not open %s.\n", device);
        return -1;
    }

    // Check the device has the correct capabilities
    struct v4l2_capability capability;

    if (xioctl(fd, VIDIOC_QUERYCAP, &capability) == -1) {
        fprintf(stderr, "ERROR: Could not read device capabilities.\n");
        return -1;
    }

    if (!(capability.capabilities & V4L2_CAP_VIDEO_CAPTURE)) {
        fprintf(stderr, "ERROR: Device can not be used for capture.\n");
        return -1;
    }

    if (!(capability.capabilities & V4L2_CAP_STREAMING)) {
        fprintf(stderr, "ERROR: Device does not support streaming.\n");
        return -1;
    }

    // Set the desired width, height, and pixel format
    struct v4l2_format format = {0};
    format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
    format.fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
    format.fmt.pix.field = V4L2_FIELD_NONE;
    format.fmt.pix.width = WIDTH;
    format.fmt.pix.height = HEIGHT;

    if (xioctl(fd, VIDIOC_S_FMT, &format) == -1) {
        fprintf(stderr, "ERROR: Could not set desired format.\n");
        return -1;
    }

    if (format.type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
        fprintf(stderr, "ERROR: Could not set device to capture mode.\n");
        return -1;
    }

    if (format.fmt.pix.pixelformat != V4L2_PIX_FMT_YUYV) {
        fprintf(stderr, "ERROR: Could not set device to use YUYV format.\n");
        return -1;
    }

    if (format.fmt.pix.width != WIDTH || format.fmt.pix.height != HEIGHT) {
        fprintf(stderr, "ERROR: Could not set device to use 800x600 format.\n");
        return -1;
    }

    // Setup request buffers
    struct v4l2_requestbuffers request_buffers = {0};
    request_buffers.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
    request_buffers.memory = V4L2_MEMORY_MMAP;
    request_buffers.count = 4;

    if (xioctl(fd, VIDIOC_REQBUFS, &request_buffers) == -1) {
        fprintf(stderr, "ERROR: Could not request buffers.\n");
        return -1;
    }

    if (request_buffers.count != 4) {
        fprintf(stderr, "ERROR: Could not request a buffer count of 4.\n");
        return -1;
    }

    // Map the buffers
    struct v4l2_buffer buffers[4]; // TODO: do I actually need to keep hold of these? Dequeue gives me it back?
    void *pointers[4]; // TODO: is there anywhere on v4l2_buffer that could store this?

    for (unsigned int i = 0; i < request_buffers.count; i++) {
        buffers[i] = (struct v4l2_buffer){0};
        buffers[i].type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
        buffers[i].memory = V4L2_MEMORY_MMAP;
        buffers[i].index = i;

        if (xioctl(fd, VIDIOC_QUERYBUF, &buffers[i]) == -1) {
            fprintf(stderr, "ERROR: Could not query buffers.\n");
            return -1;
        }

        pointers[i] = mmap(0, buffers[i].length, PROT_READ | PROT_WRITE, MAP_SHARED, fd, buffers[i].m.offset);

        if (pointers[i] == MAP_FAILED) {
            fprintf(stderr, "ERROR: Could not mmap buffers.\n");
            return -1;
        }
    }

    // Prepare for capturing
    for (unsigned int i = 0; i < request_buffers.count; i++) {
        if (xioctl(fd, VIDIOC_QBUF, &buffers[i]) == -1) {
            fprintf(stderr, "ERROR: Could not enqueue buffers.\n");
            return -1;
        }
    }
        
    // Start capturing
    enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
    if (xioctl(fd, VIDIOC_STREAMON, &type) == -1) {
        fprintf(stderr, "ERROR: Could not start capturing.\n");
        return -1;
    }

    // TODO: loop, but for now try capturing a single frame
    // {
        // Dequeue a buffer
        struct v4l2_buffer buffer = {0};
        buffer.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
        buffer.memory = V4L2_MEMORY_MMAP;
        if (xioctl(fd, VIDIOC_DQBUF, &buffer) == -1) {
            fprintf(stderr, "ERROR: Could not dequeue a buffer.\n");
            return -1;
        }

        // Grab the data
        void *data = pointers[buffer.index];
        unsigned int data_length = buffer.bytesused;
        
        // Convert the data to RGB
        unsigned char image[WIDTH*HEIGHT*3] = {0};

        for (unsigned int i = 0; i < data_length; i += 4) {
            unsigned char *bytes = data + i;
            unsigned char y1 = bytes[0];
            unsigned char cr = bytes[1];
            unsigned char y2 = bytes[2];
            unsigned char cb = bytes[3];

            float r1 = 1.164f * (y1 - 16) + 1.596f * (cr - 128);
            float g1 = 1.164f * (y1 - 16) + 0.813f * (cr - 128) - 0.391f * (cb - 128);
            float b1 = 1.164f * (y1 - 16) + 2.018f * (cb - 128);
            
            float r2 = 1.164f * (y2 - 16) + 1.596f * (cr - 128);
            float g2 = 1.164f * (y2 - 16) + 0.813f * (cr - 128) - 0.391f * (cb - 128);
            float b2 = 1.164f * (y2 - 16) + 2.018f * (cb - 128);

            image[(i/2 + 0) * 3 + 0] = fmaxf(fminf(b1, 255.0f), 0.0f);
            image[(i/2 + 0) * 3 + 1] = fmaxf(fminf(g1, 255.0f), 0.0f);
            image[(i/2 + 0) * 3 + 2] = fmaxf(fminf(r1, 255.0f), 0.0f);

            image[(i/2 + 1) * 3 + 0] = fmaxf(fminf(b2, 255.0f), 0.0f);
            image[(i/2 + 1) * 3 + 1] = fmaxf(fminf(g2, 255.0f), 0.0f);
            image[(i/2 + 1) * 3 + 2] = fmaxf(fminf(r2, 255.0f), 0.0f);
        }

        // Requeue the buffer
        if (xioctl(fd, VIDIOC_QBUF, &buffers[buffer.index]) == -1) {
            fprintf(stderr, "ERROR: Could not reenqueue buffer.\n");
            return -1;
        }
    // }

    // Stop capturing
    if (xioctl(fd, VIDIOC_STREAMOFF, &type) == -1) {
        fprintf(stderr, "ERROR: Could not stop capturing.\n");
        return -1;
    }

    // Unmap the buffers
    for (unsigned int i = 0; i < request_buffers.count; i++) {
        if (munmap(pointers[i], buffers[i].length) == -1) {
            fprintf(stderr, "ERROR: Could not munmap buffers.\n");
            return -1;
        }
    }

    // Close the device
    if (close(fd) == -1) {
        fprintf(stderr, "ERROR: Could not close %s.\n", device);
        return -1;
    }

    // TEMPORARY: display the one captured frame
    InitWindow(WIDTH, HEIGHT, "Webcam");

    Image temporary_image = GenImageColor(WIDTH, HEIGHT, BLUE);
    ImageFormat(&temporary_image, PIXELFORMAT_UNCOMPRESSED_R8G8B8);
    Texture2D texture = LoadTextureFromImage(temporary_image);
    UpdateTexture(texture, image);

    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(RED);
        DrawTexture(texture, 0, 0, WHITE);
        EndDrawing();
    }

    CloseWindow();

    return 0;
}
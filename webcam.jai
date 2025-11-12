#import "Basic";
#import "POSIX";
#import "Video_For_Linux";
#load "raylib.jai";

WIDTH :: 640;
HEIGHT :: 480;

main :: () {
    device := "/dev/video0";

    // Open the device
    fd := open(device.data, O_RDWR);

    if (fd == -1) {
        print("ERROR: Could not open %.\n", device);
        return;
    }

    defer {
        // Close the device
        if (close(fd) == -1) {
            print("ERROR: Could not close %.\n", device);
            return;
        }
    }

    // Check the device has the correct capabilities
    capability : v4l2_capability;

    if (ioctl(fd, VIDIOC_QUERYCAP, *capability) < 0) {
        print("ERROR: Could not read device capabilities.\n");
        return;
    }

    if (!(capability.capabilities & V4L2_CAP.VIDEO_CAPTURE.(u32))) {
        print("ERROR: Device can not be used for capture.\n");
        return;
    }

    if (!(capability.capabilities & V4L2_CAP.STREAMING.(u32))) {
        print("ERROR: Device does not support streaming.\n");
        return;
    }

    // Set the desired width, height, and pixel format
    format : v4l2_format;
    format.type = .VIDEO_CAPTURE;
    format.fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
    format.fmt.pix.field = .NONE;
    format.fmt.pix.width = WIDTH;
    format.fmt.pix.height = HEIGHT;

    if (ioctl(fd, VIDIOC_S_FMT, *format) < 0) {
        print("ERROR: Could not set desired format.\n");
        return;
    }

    if (format.type != .VIDEO_CAPTURE) {
        print("ERROR: Could not set device to capture mode.\n");
        return;
    }

    if (format.fmt.pix.pixelformat != V4L2_PIX_FMT_YUYV) {
        print("ERROR: Could not set device to use YUYV format.\n");
        return;
    }

    if (format.fmt.pix.width != WIDTH || format.fmt.pix.height != HEIGHT) {
        print("ERROR: Could not set device to %x% resolution.\n", WIDTH, HEIGHT);
        return;
    }

    // Setup request buffers
    request_buffers : v4l2_requestbuffers;
    request_buffers.type = .VIDEO_CAPTURE;
    request_buffers.memory = .MMAP;
    request_buffers.count = 4;

    if (ioctl(fd, VIDIOC_REQBUFS, *request_buffers) < 0) {
        print("ERROR: Could not request buffers.\n");
        return;
    }

    if (request_buffers.count != 4) {
        print("ERROR: Could not request a buffer count of 4.\n");
        return;
    }

    // Map the buffers
    buffers : [4]v4l2_buffer;
    pointers : [4]*void;

    for 0..request_buffers.count-1 {
        buffers[it].type = .VIDEO_CAPTURE;
        buffers[it].memory = .MMAP;
        buffers[it].index = it;

        if (ioctl(fd, VIDIOC_QUERYBUF, *buffers[it]) < 0) {
            print("ERROR: Could not query buffers.\n");
            return;
        }

        pointers[it] = mmap(null, buffers[it].length, PROT_READ | PROT_WRITE, MAP_SHARED, fd, buffers[it].m.offset);

        if (pointers[it] == MAP_FAILED) {
            print("ERROR: Could not mmap buffers.\n");
            return;
        }
    }

    defer {
        // Unmap the buffers
        for 0..request_buffers.count-1 {
            if (munmap(pointers[it], buffers[it].length) == -1) {
                print("ERROR: Could not munmap buffers.\n");
                return;
            }
        }
    }

    // Prepare for capturing
    for 0..request_buffers.count-1 {
        if (ioctl(fd, VIDIOC_QBUF, *buffers[it]) < 0) {
            print("ERROR: Could not enqueue buffers.\n");
            return;
        }
    }

    // Start capturing
    type := v4l2_buf_type.VIDEO_CAPTURE;
    if (ioctl(fd, VIDIOC_STREAMON, *type) < 0) {
        print("ERROR: Could not start capturing.\n");
        return;
    }

    defer {
        // Stop capturing
        if (ioctl(fd, VIDIOC_STREAMOFF, *type) < 0) {
            print("ERROR: Could not stop capturing.\n");
            return;
        }
    }

    // Set up the main loop to display frames
    SetTraceLogLevel(.WARNING);
    SetConfigFlags(.WINDOW_UNDECORATED | .WINDOW_TOPMOST | .VSYNC_HINT | .WINDOW_TRANSPARENT);
    InitWindow(WIDTH, HEIGHT, "Webcam");
    defer CloseWindow();

    scale := 1.0;
    show_stats := false;

    monitor_id := GetCurrentMonitor();
    SetTargetFPS(GetMonitorRefreshRate(monitor_id));

    temporary_image := GenImageColor(WIDTH, HEIGHT, WHITE);
    ImageFormat(*temporary_image, .UNCOMPRESSED_R8G8B8);
    ImageMipmaps(*temporary_image);
    texture := LoadTextureFromImage(temporary_image);
    UnloadImage(temporary_image);

    while !WindowShouldClose() {
        if (IsKeyPressed(.MINUS)) { scale = max(scale - 0.1, 0.3); SetWindowSize((WIDTH * scale).(s32), (HEIGHT * scale).(s32)); }
        if (IsKeyPressed(.EQUAL)) { scale = min(scale + 0.1, 1.0); SetWindowSize((WIDTH * scale).(s32), (HEIGHT * scale).(s32)); }
        if (IsKeyPressed(.F1))    { show_stats = !show_stats; }

        BeginDrawing();

        // Dequeue a buffer
        buffer : v4l2_buffer;
        buffer.type = .VIDEO_CAPTURE;
        buffer.memory = .MMAP;
        if (ioctl(fd, VIDIOC_DQBUF, *buffer) < 0) {
            print("ERROR: Could not dequeue a buffer.\n");
            return;
        }

        // Grab the data
        data := pointers[buffer.index];
        data_length := buffer.bytesused;

        // Convert the data to RGB
        image : [WIDTH * HEIGHT * 3]u8;

        for 0..(data_length-1)/4 {
            i := it * 4;

            bytes := (data + i).(*u8);
            y1 := bytes[0];
            cr := bytes[1];
            y2 := bytes[2];
            cb := bytes[3];

            r1 := 1.164 * (y1 - 16) + 1.596 * (cr - 128);
            g1 := 1.164 * (y1 - 16) + 0.813 * (cr - 128) - 0.391 * (cb - 128);
            b1 := 1.164 * (y1 - 16) + 2.018 * (cb - 128);

            r2 := 1.164 * (y2 - 16) + 1.596 * (cr - 128);
            g2 := 1.164 * (y2 - 16) + 0.813 * (cr - 128) - 0.391 * (cb - 128);
            b2 := 1.164 * (y2 - 16) + 2.018 * (cb - 128);

            image[(i/2 + 0) * 3 + 0] = max(min(b1, 255.0), 0.0).(u8);
            image[(i/2 + 0) * 3 + 1] = max(min(g1, 255.0), 0.0).(u8);
            image[(i/2 + 0) * 3 + 2] = max(min(r1, 255.0), 0.0).(u8);

            image[(i/2 + 1) * 3 + 0] = max(min(b2, 255.0), 0.0).(u8);
            image[(i/2 + 1) * 3 + 1] = max(min(g2, 255.0), 0.0).(u8);
            image[(i/2 + 1) * 3 + 2] = max(min(r2, 255.0), 0.0).(u8);
        }

        // Requeue the buffer
        if (ioctl(fd, VIDIOC_QBUF, *buffers[buffer.index]) < 0) {
            print("ERROR: Could not reenqueue buffer.\n");
            return;
        }

        // Upload to the GPU
        UpdateTexture(texture, image.data);
        GenTextureMipmaps(*texture);

        // Draw it
        src := Rectangle.{0, 0, WIDTH, HEIGHT};
        dst := Rectangle.{0, 0, WIDTH * scale, HEIGHT * scale};
        DrawTexturePro(texture, src, dst, .{}, 0, WHITE);

        if (show_stats) {
            DrawFPS(25, 25);
        }

        EndDrawing();
    }
}
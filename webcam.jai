#import "Basic";
#import "POSIX";
#import "Video_For_Linux";
#load "raylib.jai";

WIDTH  :: 640;
HEIGHT :: 480;
DEVICE :: "/dev/video0";

main :: () {
    // Open the device
    fd := open(DEVICE.data, O_RDWR);

    check(fd >= 0, tprint("Could not open %", DEVICE));

    // Check the device has the correct capabilities
    capability : v4l2_capability;

    check(ioctl(fd, VIDIOC_QUERYCAP, *capability) >= 0, "Could not read device capabilities");
    check(capability.capabilities & V4L2_CAP.VIDEO_CAPTURE.(u32) != 0, "Device can not be used for capture");
    check(capability.capabilities & V4L2_CAP.STREAMING.(u32) != 0, "Device does not support streaming");

    // Set the desired width, height, and pixel format
    format : v4l2_format;
    format.type = .VIDEO_CAPTURE;
    format.fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
    format.fmt.pix.field = .NONE;
    format.fmt.pix.width = WIDTH;
    format.fmt.pix.height = HEIGHT;

    check(ioctl(fd, VIDIOC_S_FMT, *format) >= 0, "Could not set desired format");
    check(format.type == .VIDEO_CAPTURE, "Could not set device to capture mode");
    check(format.fmt.pix.pixelformat == V4L2_PIX_FMT_YUYV, "Could not set device to use YUYV format");
    check(format.fmt.pix.width == WIDTH && format.fmt.pix.height == HEIGHT, tprint("Could not set device to %x% resolution", WIDTH, HEIGHT));

    // Setup request buffers
    request_buffers : v4l2_requestbuffers;
    request_buffers.type = .VIDEO_CAPTURE;
    request_buffers.memory = .MMAP;
    request_buffers.count = 4;

    check(ioctl(fd, VIDIOC_REQBUFS, *request_buffers) >= 0, "Could not request buffers");
    check(request_buffers.count == 4, "Could not request a buffer count of 4");

    // Map the buffers
    buffers : [4]v4l2_buffer;
    pointers : [4]*void;

    for 0..request_buffers.count-1 {
        buffers[it].type = .VIDEO_CAPTURE;
        buffers[it].memory = .MMAP;
        buffers[it].index = it;

        check(ioctl(fd, VIDIOC_QUERYBUF, *buffers[it]) >= 0, "Could not query buffers");
        pointers[it] = mmap(null, buffers[it].length, PROT_READ | PROT_WRITE, MAP_SHARED, fd, buffers[it].m.offset);
        check(pointers[it] != MAP_FAILED, "Could not mmap buffers");
    }

    // Prepare for capturing
    for 0..request_buffers.count-1 {
        check(ioctl(fd, VIDIOC_QBUF, *buffers[it]) >= 0, "Could not enqueue buffers");
    }

    // Start capturing
    type := v4l2_buf_type.VIDEO_CAPTURE;
    check(ioctl(fd, VIDIOC_STREAMON, *type) >= 0, "Could not start capturing");

    // Set up the main loop to display frames
    SetTraceLogLevel(.WARNING);
    SetConfigFlags(.WINDOW_UNDECORATED | .WINDOW_TOPMOST | .VSYNC_HINT | .WINDOW_TRANSPARENT);
    InitWindow(WIDTH, HEIGHT, "Webcam");

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
        check(ioctl(fd, VIDIOC_DQBUF, *buffer) >= 0, "Could not dequeue a buffer");

        // Grab the data
        data := pointers[buffer.index];
        data_length := buffer.bytesused;

        // Convert the data to RGB
        image : [WIDTH * HEIGHT * 3]u8;

        for i: 0..(data_length-1)/4 {
            bytes := (data + i * 4).(*u8);
            y1, cr, y2, cb := bytes[0], bytes[1], bytes[2], bytes[3];

            r1 := 1.164 * (y1 - 16.0) + 1.596 * (cr - 128.0);
            g1 := 1.164 * (y1 - 16.0) + 0.813 * (cr - 128.0) - 0.391 * (cb - 128.0);
            b1 := 1.164 * (y1 - 16.0) + 2.018 * (cb - 128.0);

            r2 := 1.164 * (y2 - 16.0) + 1.596 * (cr - 128.0);
            g2 := 1.164 * (y2 - 16.0) + 0.813 * (cr - 128.0) - 0.391 * (cb - 128.0);
            b2 := 1.164 * (y2 - 16.0) + 2.018 * (cb - 128.0);

            image[(i*2 + 0) * 3 + 0] = clamp(b1, 0.0, 255.0).(u8);
            image[(i*2 + 0) * 3 + 1] = clamp(g1, 0.0, 255.0).(u8);
            image[(i*2 + 0) * 3 + 2] = clamp(r1, 0.0, 255.0).(u8);

            image[(i*2 + 1) * 3 + 0] = clamp(b2, 0.0, 255.0).(u8);
            image[(i*2 + 1) * 3 + 1] = clamp(g2, 0.0, 255.0).(u8);
            image[(i*2 + 1) * 3 + 2] = clamp(r2, 0.0, 255.0).(u8);
        }

        // Requeue the buffer
        check(ioctl(fd, VIDIOC_QBUF, *buffers[buffer.index]) >= 0, "Could not reenqueue buffer");

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

    CloseWindow();

    // Stop capturing
    check(ioctl(fd, VIDIOC_STREAMOFF, *type) >= 0, "Could not stop capturing");

    // Unmap the buffers
    for 0..request_buffers.count-1 {
        check(munmap(pointers[it], buffers[it].length) >= 0, "Could not munmap buffers");
    }

    // Close the device
    check(close(fd) >= 0, tprint("Could not close %", DEVICE));
}

check :: (value: bool, message: string) {
    if value return;
    print("ERROR: %.\n", message);
    exit(0);
}
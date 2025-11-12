//
// Test the ioctl values match the values calculated from c hearders.
//

#import "Basic";
#import,dir "../../Video_For_Linux";


main :: () {
    print("size_of(v4l2_dv_timings) == %\n", size_of(v4l2_dv_timings));

    print("Printing values for % ioctl codes:\n", IOCTL_CODES.count);
    #insert -> string {
        b: String_Builder; 
        for IOCTL_CODES {
            print(*b, "print(\"% :: 0x\%;\\n\", formatInt(%, base=16, minimum_digits=8));\n", it, it); // Got to be a cleaner way to do this...
        }
        return builder_to_string(*b);
    }
}

IOCTL_CODES :: string.[
    "VIDIOC_QUERYCAP",
    "VIDIOC_ENUM_FMT",
    "VIDIOC_G_FMT",
    "VIDIOC_S_FMT",
    "VIDIOC_REQBUFS",
    "VIDIOC_QUERYBUF",
    "VIDIOC_G_FBUF",
    "VIDIOC_S_FBUF",
    "VIDIOC_OVERLAY",
    "VIDIOC_QBUF",
    "VIDIOC_EXPBUF",
    "VIDIOC_DQBUF",
    "VIDIOC_STREAMON",
    "VIDIOC_STREAMOFF",
    "VIDIOC_G_PARM",
    "VIDIOC_S_PARM",
    "VIDIOC_G_STD",
    "VIDIOC_S_STD",
    "VIDIOC_ENUMSTD",
    "VIDIOC_ENUMINPUT",
    "VIDIOC_G_CTRL",
    "VIDIOC_S_CTRL",
    "VIDIOC_G_TUNER",
    "VIDIOC_S_TUNER",
    "VIDIOC_G_AUDIO",
    "VIDIOC_S_AUDIO",
    "VIDIOC_QUERYCTRL",
    "VIDIOC_QUERYMENU",
    "VIDIOC_G_INPUT",
    "VIDIOC_S_INPUT",
    "VIDIOC_G_EDID",
    "VIDIOC_S_EDID",
    "VIDIOC_G_OUTPUT",
    "VIDIOC_S_OUTPUT",
    "VIDIOC_ENUMOUTPUT",
    "VIDIOC_G_AUDOUT",
    "VIDIOC_S_AUDOUT",
    "VIDIOC_G_MODULATOR",
    "VIDIOC_S_MODULATOR",
    "VIDIOC_G_FREQUENCY",
    "VIDIOC_S_FREQUENCY",
    "VIDIOC_CROPCAP",
    "VIDIOC_G_CROP",
    "VIDIOC_S_CROP",
    "VIDIOC_G_JPEGCOMP",
    "VIDIOC_S_JPEGCOMP",
    "VIDIOC_QUERYSTD",
    "VIDIOC_TRY_FMT",
    "VIDIOC_ENUMAUDIO",
    "VIDIOC_ENUMAUDOUT",
    "VIDIOC_G_PRIORITY",
    "VIDIOC_S_PRIORITY",
    "VIDIOC_G_SLICED_VBI_CAP",
    "VIDIOC_LOG_STATUS",
    "VIDIOC_G_EXT_CTRLS",
    "VIDIOC_S_EXT_CTRLS",
    "VIDIOC_TRY_EXT_CTRLS",
    "VIDIOC_ENUM_FRAMESIZES",
    "VIDIOC_ENUM_FRAMEINTERVALS",
    "VIDIOC_G_ENC_INDEX",
    "VIDIOC_ENCODER_CMD",
    "VIDIOC_TRY_ENCODER_CMD",


    "VIDIOC_DBG_S_REGISTER",
    "VIDIOC_DBG_G_REGISTER",

    "VIDIOC_S_HW_FREQ_SEEK",
    "VIDIOC_S_DV_TIMINGS",
    "VIDIOC_G_DV_TIMINGS",
    "VIDIOC_DQEVENT",
    "VIDIOC_SUBSCRIBE_EVENT",
    "VIDIOC_UNSUBSCRIBE_EVENT",
    "VIDIOC_CREATE_BUFS",
    "VIDIOC_PREPARE_BUF",
    "VIDIOC_G_SELECTION",
    "VIDIOC_S_SELECTION",
    "VIDIOC_DECODER_CMD",
    "VIDIOC_TRY_DECODER_CMD",
    "VIDIOC_ENUM_DV_TIMINGS",
    "VIDIOC_QUERY_DV_TIMINGS",
    "VIDIOC_DV_TIMINGS_CAP",
    "VIDIOC_ENUM_FREQ_BANDS",

    "VIDIOC_DBG_G_CHIP_INFO",
    "VIDIOC_QUERY_EXT_CTRL",
];
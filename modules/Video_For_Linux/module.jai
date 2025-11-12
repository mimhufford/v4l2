//
// Bindings for Video for Linux (v4l2) api.
//

// @Incomplete: Some ioctl codes, eg VIDIOC_S_DV_TIMINGS, resolve to the wrong value due to the size of the type being different in jai bindings compared to c headers. Bindings_Generator _is_ adding #no_padding directives, but that is not handling the issue. For now I have just commented these ones out. Maybe I should just manually paste the values in like is suggested below?
// @Incomplete: More struct members could be generated to use the actual enum type instead of u32, like v4l2_format.type has.
// @Incomplete: More of the defines could be made into enums/enum_flags like is done for V4L2_CAP_*

// There is one procedure in videodev2.h, the inline procedure:
v4l2_timeval_to_ns :: (tv: *timeval) -> u64 {
    result := cast(u64, tv.tv_sec) * 1_000_000_000 + tv.tv_usec * 1_000;
    return result;
}

#load "bindings.jai";

//
// Pixel formats. These are defines using the v412_fourcc macro in headers. Just manually doing here
//
// @Incomplete: There are tons of these pixel formats. For now I have just defined the ones I need...

v4l2_fourcc :: (a: u8, b: u8, c: u8, d: u8) -> u32 #expand {
    result: u32;
    result |= cast(u32, a) << 0;
    result |= cast(u32, b) << 8;
    result |= cast(u32, c) << 16;
    result |= cast(u32, d) << 24;
    return result;
}

// Convert a pixel format value back to a readable string for debugging. It would be better to have the pixel formats as enum or something?
v4l2_fourcc_to_string :: (fourcc: u32) -> string #expand {
    // This is a macro so hopefully this statically allocated character data is fine?
    characters: [4] u8;
    // Basic :: #import "Basic";
    // s := Basic.alloc_string(4); // Pretty hack, whatever.

    characters[0] = cast,no_check(u8, fourcc >> 0);
    characters[1] = cast,no_check(u8, fourcc >> 8);
    characters[2] = cast,no_check(u8, fourcc >> 16);
    characters[3] = cast,no_check(u8, fourcc >> 24);

    s := string.{4, characters.data};

    return s;
}

V4L2_PIX_FMT_YUYV  :: #run v4l2_fourcc(#char "Y", #char "U", #char "Y", #char "V"); /* 16  YUV 4:2:2     */
V4L2_PIX_FMT_JPEG  :: #run v4l2_fourcc(#char "J", #char "P", #char "E", #char "G"); /* JFIF JPEG     */
V4L2_PIX_FMT_MJPEG :: #run v4l2_fourcc(#char "M", #char "J", #char "P", #char "G"); /* Motion-JPEG   */
V4L2_PIX_FMT_H264  :: #run v4l2_fourcc(#char "H", #char "2", #char "6", #char "4"); /* H264 with start codes */

#load "ioctl.jai";


// NOTE(Charles): This is a whole lotta runs to define these things... Maybe just run it once and paste the defines in. Or if there
// is some reason to be doing this dynamically, then do in one run and insert the lot at once?

/*
 *  I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
 *
 */
VIDIOC_QUERYCAP            :: #run _IOR(#char "V",  0, v4l2_capability);
VIDIOC_ENUM_FMT            :: #run _IOWR(#char "V",  2, v4l2_fmtdesc);
VIDIOC_G_FMT               :: #run _IOWR(#char "V",  4, v4l2_format);
VIDIOC_S_FMT               :: #run _IOWR(#char "V",  5, v4l2_format);
VIDIOC_REQBUFS             :: #run _IOWR(#char "V",  8, v4l2_requestbuffers);
VIDIOC_QUERYBUF            :: #run _IOWR(#char "V",  9, v4l2_buffer);
VIDIOC_G_FBUF              :: #run _IOR(#char "V", 10, v4l2_framebuffer);
VIDIOC_S_FBUF              :: #run _IOW(#char "V", 11, v4l2_framebuffer);
VIDIOC_OVERLAY             :: #run _IOW(#char "V", 14, s32);
VIDIOC_QBUF                :: #run _IOWR(#char "V", 15, v4l2_buffer);
VIDIOC_EXPBUF              :: #run _IOWR(#char "V", 16, v4l2_exportbuffer);
VIDIOC_DQBUF               :: #run _IOWR(#char "V", 17, v4l2_buffer);
VIDIOC_STREAMON            :: #run _IOW(#char "V", 18, s32);
VIDIOC_STREAMOFF           :: #run _IOW(#char "V", 19, s32);
VIDIOC_G_PARM              :: #run _IOWR(#char "V", 21, v4l2_streamparm);
VIDIOC_S_PARM              :: #run _IOWR(#char "V", 22, v4l2_streamparm);
VIDIOC_G_STD               :: #run _IOR(#char "V", 23, v4l2_std_id);
VIDIOC_S_STD               :: #run _IOW(#char "V", 24, v4l2_std_id);
VIDIOC_ENUMSTD             :: #run _IOWR(#char "V", 25, v4l2_standard);
VIDIOC_ENUMINPUT           :: #run _IOWR(#char "V", 26, v4l2_input);
VIDIOC_G_CTRL              :: #run _IOWR(#char "V", 27, v4l2_control);
VIDIOC_S_CTRL              :: #run _IOWR(#char "V", 28, v4l2_control);
VIDIOC_G_TUNER             :: #run _IOWR(#char "V", 29, v4l2_tuner);
VIDIOC_S_TUNER             :: #run _IOW(#char "V", 30, v4l2_tuner);
VIDIOC_G_AUDIO             :: #run _IOR(#char "V", 33, v4l2_audio);
VIDIOC_S_AUDIO             :: #run _IOW(#char "V", 34, v4l2_audio);
VIDIOC_QUERYCTRL           :: #run _IOWR(#char "V", 36, v4l2_queryctrl);
VIDIOC_QUERYMENU           :: #run _IOWR(#char "V", 37, v4l2_querymenu);
VIDIOC_G_INPUT             :: #run _IOR(#char "V", 38, s32);
VIDIOC_S_INPUT             :: #run _IOWR(#char "V", 39, s32);
VIDIOC_G_EDID              :: #run _IOWR(#char "V", 40, v4l2_edid);
VIDIOC_S_EDID              :: #run _IOWR(#char "V", 41, v4l2_edid);
VIDIOC_G_OUTPUT            :: #run _IOR(#char "V", 46, s32);
VIDIOC_S_OUTPUT            :: #run _IOWR(#char "V", 47, s32);
VIDIOC_ENUMOUTPUT          :: #run _IOWR(#char "V", 48, v4l2_output);
VIDIOC_G_AUDOUT            :: #run _IOR(#char "V", 49, v4l2_audioout);
VIDIOC_S_AUDOUT            :: #run _IOW(#char "V", 50, v4l2_audioout);
VIDIOC_G_MODULATOR         :: #run _IOWR(#char "V", 54, v4l2_modulator);
VIDIOC_S_MODULATOR         :: #run _IOW(#char "V", 55, v4l2_modulator);
VIDIOC_G_FREQUENCY         :: #run _IOWR(#char "V", 56, v4l2_frequency);
VIDIOC_S_FREQUENCY         :: #run _IOW(#char "V", 57, v4l2_frequency);
VIDIOC_CROPCAP             :: #run _IOWR(#char "V", 58, v4l2_cropcap);
VIDIOC_G_CROP              :: #run _IOWR(#char "V", 59, v4l2_crop);
VIDIOC_S_CROP              :: #run _IOW(#char "V", 60, v4l2_crop);
VIDIOC_G_JPEGCOMP          :: #run _IOR(#char "V", 61, v4l2_jpegcompression);
VIDIOC_S_JPEGCOMP          :: #run _IOW(#char "V", 62, v4l2_jpegcompression);
VIDIOC_QUERYSTD            :: #run _IOR(#char "V", 63, v4l2_std_id);
VIDIOC_TRY_FMT             :: #run _IOWR(#char "V", 64, v4l2_format);
VIDIOC_ENUMAUDIO           :: #run _IOWR(#char "V", 65, v4l2_audio);
VIDIOC_ENUMAUDOUT          :: #run _IOWR(#char "V", 66, v4l2_audioout);
VIDIOC_G_PRIORITY          :: #run _IOR(#char "V", 67, u32) /* enum v4l2_priority */;
VIDIOC_S_PRIORITY          :: #run _IOW(#char "V", 68, u32) /* enum v4l2_priority */;
VIDIOC_G_SLICED_VBI_CAP    :: #run _IOWR(#char "V", 69, v4l2_sliced_vbi_cap);
VIDIOC_LOG_STATUS          :: #run _IO(#char "V", 70);
VIDIOC_G_EXT_CTRLS         :: #run _IOWR(#char "V", 71, v4l2_ext_controls);
VIDIOC_S_EXT_CTRLS         :: #run _IOWR(#char "V", 72, v4l2_ext_controls);
VIDIOC_TRY_EXT_CTRLS       :: #run _IOWR(#char "V", 73, v4l2_ext_controls);
VIDIOC_ENUM_FRAMESIZES     :: #run _IOWR(#char "V", 74, v4l2_frmsizeenum);
VIDIOC_ENUM_FRAMEINTERVALS :: #run _IOWR(#char "V", 75, v4l2_frmivalenum);
VIDIOC_G_ENC_INDEX         :: #run _IOR(#char "V", 76, v4l2_enc_idx);
VIDIOC_ENCODER_CMD         :: #run _IOWR(#char "V", 77, v4l2_encoder_cmd);
VIDIOC_TRY_ENCODER_CMD     :: #run _IOWR(#char "V", 78, v4l2_encoder_cmd);

/*
 * Experimental, meant for debugging, testing and internal use.
 * Only implemented if CONFIG_VIDEO_ADV_DEBUG is defined.
 * You must be root to use these ioctls. Never use these in applications!
 */
VIDIOC_DBG_S_REGISTER :: #run _IOW(#char "V", 79, v4l2_dbg_register);
VIDIOC_DBG_G_REGISTER :: #run _IOWR(#char "V", 80, v4l2_dbg_register);

VIDIOC_S_HW_FREQ_SEEK    :: #run _IOW(#char "V", 82, v4l2_hw_freq_seek);
// VIDIOC_S_DV_TIMINGS      :: #run _IOWR(#char "V", 87, v4l2_dv_timings);
// VIDIOC_G_DV_TIMINGS      :: #run _IOWR(#char "V", 88, v4l2_dv_timings);
VIDIOC_DQEVENT           :: #run _IOR(#char "V", 89, v4l2_event);
VIDIOC_SUBSCRIBE_EVENT   :: #run _IOW(#char "V", 90, v4l2_event_subscription);
VIDIOC_UNSUBSCRIBE_EVENT :: #run _IOW(#char "V", 91, v4l2_event_subscription);
VIDIOC_CREATE_BUFS       :: #run _IOWR(#char "V", 92, v4l2_create_buffers);
VIDIOC_PREPARE_BUF       :: #run _IOWR(#char "V", 93, v4l2_buffer);
VIDIOC_G_SELECTION       :: #run _IOWR(#char "V", 94, v4l2_selection);
VIDIOC_S_SELECTION       :: #run _IOWR(#char "V", 95, v4l2_selection);
VIDIOC_DECODER_CMD       :: #run _IOWR(#char "V", 96, v4l2_decoder_cmd);
VIDIOC_TRY_DECODER_CMD   :: #run _IOWR(#char "V", 97, v4l2_decoder_cmd);
// VIDIOC_ENUM_DV_TIMINGS   :: #run _IOWR(#char "V", 98, v4l2_enum_dv_timings);
// VIDIOC_QUERY_DV_TIMINGS  :: #run _IOR(#char "V", 99, v4l2_dv_timings);
VIDIOC_DV_TIMINGS_CAP    :: #run _IOWR(#char "V", 100, v4l2_dv_timings_cap);
VIDIOC_ENUM_FREQ_BANDS   :: #run _IOWR(#char "V", 101, v4l2_frequency_band);

/*
 * Experimental, meant for debugging, testing and internal use.
 * Never use this in applications!
 */
VIDIOC_DBG_G_CHIP_INFO :: #run _IOWR(#char "V", 102, v4l2_dbg_chip_info);
VIDIOC_QUERY_EXT_CTRL  :: #run _IOWR(#char "V", 103, v4l2_query_ext_ctrl);

// NOTE(Charles):  // Not in version of headers in my wsl ubuntu, but is on pi :shrug:
// VIDIOC_REMOVE_BUFS :: #run _IOWR(#char "V", 104, v4l2_remove_buffers);

#scope_module

#import "POSIX";
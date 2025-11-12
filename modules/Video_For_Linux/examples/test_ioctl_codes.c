//
// C program to compare the resolved macro values to jai bindings. Probably @Temporary.
//

#include <linux/videodev2.h>
#include <stdio.h>

int main() {
    printf("sizeof(v4l2_dv_timings) == %lu\n", sizeof(struct v4l2_dv_timings));

    printf("VIDIOC_QUERYCAP :: 0x%08lx;\n", VIDIOC_QUERYCAP);
    printf("VIDIOC_ENUM_FMT :: 0x%08lx;\n", VIDIOC_ENUM_FMT);
    printf("VIDIOC_G_FMT :: 0x%08lx;\n", VIDIOC_G_FMT);
    printf("VIDIOC_S_FMT :: 0x%08lx;\n", VIDIOC_S_FMT);
    printf("VIDIOC_REQBUFS :: 0x%08lx;\n", VIDIOC_REQBUFS);
    printf("VIDIOC_QUERYBUF :: 0x%08lx;\n", VIDIOC_QUERYBUF);
    printf("VIDIOC_G_FBUF :: 0x%08lx;\n", VIDIOC_G_FBUF);
    printf("VIDIOC_S_FBUF :: 0x%08lx;\n", VIDIOC_S_FBUF);
    printf("VIDIOC_OVERLAY :: 0x%08lx;\n", VIDIOC_OVERLAY);
    printf("VIDIOC_QBUF :: 0x%08lx;\n", VIDIOC_QBUF);
    printf("VIDIOC_EXPBUF :: 0x%08lx;\n", VIDIOC_EXPBUF);
    printf("VIDIOC_DQBUF :: 0x%08lx;\n", VIDIOC_DQBUF);
    printf("VIDIOC_STREAMON :: 0x%08lx;\n", VIDIOC_STREAMON);
    printf("VIDIOC_STREAMOFF :: 0x%08lx;\n", VIDIOC_STREAMOFF);
    printf("VIDIOC_G_PARM :: 0x%08lx;\n", VIDIOC_G_PARM);
    printf("VIDIOC_S_PARM :: 0x%08lx;\n", VIDIOC_S_PARM);
    printf("VIDIOC_G_STD :: 0x%08lx;\n", VIDIOC_G_STD);
    printf("VIDIOC_S_STD :: 0x%08lx;\n", VIDIOC_S_STD);
    printf("VIDIOC_ENUMSTD :: 0x%08lx;\n", VIDIOC_ENUMSTD);
    printf("VIDIOC_ENUMINPUT :: 0x%08lx;\n", VIDIOC_ENUMINPUT);
    printf("VIDIOC_G_CTRL :: 0x%08lx;\n", VIDIOC_G_CTRL);
    printf("VIDIOC_S_CTRL :: 0x%08lx;\n", VIDIOC_S_CTRL);
    printf("VIDIOC_G_TUNER :: 0x%08lx;\n", VIDIOC_G_TUNER);
    printf("VIDIOC_S_TUNER :: 0x%08lx;\n", VIDIOC_S_TUNER);
    printf("VIDIOC_G_AUDIO :: 0x%08lx;\n", VIDIOC_G_AUDIO);
    printf("VIDIOC_S_AUDIO :: 0x%08lx;\n", VIDIOC_S_AUDIO);
    printf("VIDIOC_QUERYCTRL :: 0x%08lx;\n", VIDIOC_QUERYCTRL);
    printf("VIDIOC_QUERYMENU :: 0x%08lx;\n", VIDIOC_QUERYMENU);
    printf("VIDIOC_G_INPUT :: 0x%08lx;\n", VIDIOC_G_INPUT);
    printf("VIDIOC_S_INPUT :: 0x%08lx;\n", VIDIOC_S_INPUT);
    printf("VIDIOC_G_EDID :: 0x%08lx;\n", VIDIOC_G_EDID);
    printf("VIDIOC_S_EDID :: 0x%08lx;\n", VIDIOC_S_EDID);
    printf("VIDIOC_G_OUTPUT :: 0x%08lx;\n", VIDIOC_G_OUTPUT);
    printf("VIDIOC_S_OUTPUT :: 0x%08lx;\n", VIDIOC_S_OUTPUT);
    printf("VIDIOC_ENUMOUTPUT :: 0x%08lx;\n", VIDIOC_ENUMOUTPUT);
    printf("VIDIOC_G_AUDOUT :: 0x%08lx;\n", VIDIOC_G_AUDOUT);
    printf("VIDIOC_S_AUDOUT :: 0x%08lx;\n", VIDIOC_S_AUDOUT);
    printf("VIDIOC_G_MODULATOR :: 0x%08lx;\n", VIDIOC_G_MODULATOR);
    printf("VIDIOC_S_MODULATOR :: 0x%08lx;\n", VIDIOC_S_MODULATOR);
    printf("VIDIOC_G_FREQUENCY :: 0x%08lx;\n", VIDIOC_G_FREQUENCY);
    printf("VIDIOC_S_FREQUENCY :: 0x%08lx;\n", VIDIOC_S_FREQUENCY);
    printf("VIDIOC_CROPCAP :: 0x%08lx;\n", VIDIOC_CROPCAP);
    printf("VIDIOC_G_CROP :: 0x%08lx;\n", VIDIOC_G_CROP);
    printf("VIDIOC_S_CROP :: 0x%08lx;\n", VIDIOC_S_CROP);
    printf("VIDIOC_G_JPEGCOMP :: 0x%08lx;\n", VIDIOC_G_JPEGCOMP);
    printf("VIDIOC_S_JPEGCOMP :: 0x%08lx;\n", VIDIOC_S_JPEGCOMP);
    printf("VIDIOC_QUERYSTD :: 0x%08lx;\n", VIDIOC_QUERYSTD);
    printf("VIDIOC_TRY_FMT :: 0x%08lx;\n", VIDIOC_TRY_FMT);
    printf("VIDIOC_ENUMAUDIO :: 0x%08lx;\n", VIDIOC_ENUMAUDIO);
    printf("VIDIOC_ENUMAUDOUT :: 0x%08lx;\n", VIDIOC_ENUMAUDOUT);
    printf("VIDIOC_G_PRIORITY :: 0x%08lx;\n", VIDIOC_G_PRIORITY);
    printf("VIDIOC_S_PRIORITY :: 0x%08lx;\n", VIDIOC_S_PRIORITY);
    printf("VIDIOC_G_SLICED_VBI_CAP :: 0x%08lx;\n", VIDIOC_G_SLICED_VBI_CAP);
    printf("VIDIOC_LOG_STATUS :: 0x%08lx;\n", VIDIOC_LOG_STATUS);
    printf("VIDIOC_G_EXT_CTRLS :: 0x%08lx;\n", VIDIOC_G_EXT_CTRLS);
    printf("VIDIOC_S_EXT_CTRLS :: 0x%08lx;\n", VIDIOC_S_EXT_CTRLS);
    printf("VIDIOC_TRY_EXT_CTRLS :: 0x%08lx;\n", VIDIOC_TRY_EXT_CTRLS);
    printf("VIDIOC_ENUM_FRAMESIZES :: 0x%08lx;\n", VIDIOC_ENUM_FRAMESIZES);
    printf("VIDIOC_ENUM_FRAMEINTERVALS :: 0x%08lx;\n", VIDIOC_ENUM_FRAMEINTERVALS);
    printf("VIDIOC_G_ENC_INDEX :: 0x%08lx;\n", VIDIOC_G_ENC_INDEX);
    printf("VIDIOC_ENCODER_CMD :: 0x%08lx;\n", VIDIOC_ENCODER_CMD);
    printf("VIDIOC_TRY_ENCODER_CMD :: 0x%08lx;\n", VIDIOC_TRY_ENCODER_CMD);
    printf("VIDIOC_DBG_S_REGISTER :: 0x%08lx;\n", VIDIOC_DBG_S_REGISTER);
    printf("VIDIOC_DBG_G_REGISTER :: 0x%08lx;\n", VIDIOC_DBG_G_REGISTER);
    printf("VIDIOC_S_HW_FREQ_SEEK :: 0x%08lx;\n", VIDIOC_S_HW_FREQ_SEEK);
    printf("VIDIOC_S_DV_TIMINGS :: 0x%08lx;\n", VIDIOC_S_DV_TIMINGS);
    printf("VIDIOC_G_DV_TIMINGS :: 0x%08lx;\n", VIDIOC_G_DV_TIMINGS);
    printf("VIDIOC_DQEVENT :: 0x%08lx;\n", VIDIOC_DQEVENT);
    printf("VIDIOC_SUBSCRIBE_EVENT :: 0x%08lx;\n", VIDIOC_SUBSCRIBE_EVENT);
    printf("VIDIOC_UNSUBSCRIBE_EVENT :: 0x%08lx;\n", VIDIOC_UNSUBSCRIBE_EVENT);
    printf("VIDIOC_CREATE_BUFS :: 0x%08lx;\n", VIDIOC_CREATE_BUFS);
    printf("VIDIOC_PREPARE_BUF :: 0x%08lx;\n", VIDIOC_PREPARE_BUF);
    printf("VIDIOC_G_SELECTION :: 0x%08lx;\n", VIDIOC_G_SELECTION);
    printf("VIDIOC_S_SELECTION :: 0x%08lx;\n", VIDIOC_S_SELECTION);
    printf("VIDIOC_DECODER_CMD :: 0x%08lx;\n", VIDIOC_DECODER_CMD);
    printf("VIDIOC_TRY_DECODER_CMD :: 0x%08lx;\n", VIDIOC_TRY_DECODER_CMD);
    printf("VIDIOC_ENUM_DV_TIMINGS :: 0x%08lx;\n", VIDIOC_ENUM_DV_TIMINGS);
    printf("VIDIOC_QUERY_DV_TIMINGS :: 0x%08lx;\n", VIDIOC_QUERY_DV_TIMINGS);
    printf("VIDIOC_DV_TIMINGS_CAP :: 0x%08lx;\n", VIDIOC_DV_TIMINGS_CAP);
    printf("VIDIOC_ENUM_FREQ_BANDS :: 0x%08lx;\n", VIDIOC_ENUM_FREQ_BANDS);
    printf("VIDIOC_DBG_G_CHIP_INFO :: 0x%08lx;\n", VIDIOC_DBG_G_CHIP_INFO);
    printf("VIDIOC_QUERY_EXT_CTRL :: 0x%08lx;\n", VIDIOC_QUERY_EXT_CTRL);

    return 0;
}

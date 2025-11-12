//
// Generate bindings for Video for Linux (v4l2) api https://www.kernel.org/doc/html/v4.9/media/uapi/v4l/v4l2.html
// 

// Installed with `sudo apt install libv4l-dev`

AT_COMPILE_TIME :: true;

DECLARATIONS_TO_OMIT :: string.[
];

generate :: (args: [] string) -> bool {
    os_target := OS;
    cpu_target := CPU;
    if array_find(args, "-pi") cpu_target = .ARM64;

    print("Generating bindings...\n");
    output_filename: string;
    opts: Generate_Bindings_Options;
    {
        using opts;

        os = os_target;
        cpu = cpu_target;
        alias_original_enum_names           = false;
        log_stripped_declarations           = true;
        generate_compile_time_struct_checks = false;
        try_to_preserve_comments            = true;

        generate_library_declarations = true;

        assert(os_target == .LINUX, "Linux only api init. % is not supported", os_target);

        output_filename = "bindings.jai";

        array_add(*path_fragments_to_treat_as_non_system_paths, "videodev2", "v4l2");

        // NOTE(Charles): I hoped that adding this would magically make Bindings_Generator unwrap all the annoying macros that define the 
        // ioctl codes for v4l. It did not. Sadge.
        // array_add(*path_fragments_to_treat_as_non_system_paths, "ioctl");

        system_include_path := get_libc_paths();
        array_add(*source_files, tprint("%/linux/videodev2.h", system_include_path));

        // There is no library? Just header stuff.
        // array_add(*system_library_names, ""); 

        visitor = v4l2_visitor;

        array_add(*typedef_prefixes_to_unwrap, "__le32");

        array_add(*generate_enums_from_macros_with_prefixes, ..V4L2_MACRO_ENUM_TYPES);
        array_add(*generate_enums_from_macros_with_prefixes, ..V4L2_MACRO_ENUM_FLAG_TYPES);
    }

    return generate_bindings(opts, output_filename);
}

// NOTE(Charles): Could maybe also rename these?

V4L2_MACRO_ENUM_TYPES :: string.[
    "V4L2_INPUT_TYPE",
    "V4L2_STD", // Video Standard
];

V4L2_MACRO_ENUM_FLAG_TYPES :: string.[
    "V4L2_CAP",
    "V4L2_IN_ST",  // Input status
    "V4L2_IN_CAP", // Input capability
    "V4L2_BUF_FLAG",
    "V4L2_FMT_FLAG", // Image format description flags
];


v4l2_visitor :: (decl: *Declaration, parent_decl: *Declaration) -> Declaration_Visit_Result {
    // Replace integers with their corresponding enum flags, where possible
    if parent_decl && parent_decl.kind == .STRUCT && decl.kind == .DECLARATION && decl.type.number_flags {
        new_name := get_enum_name(decl.name, parent_decl.name);
        if new_name {
            print("% -> %\n", decl.name, new_name);
            change_type_to_enum(decl, new_name);
        }
    }

    if !parent_decl {
        if decl.kind == .ENUM {
            e := cast(*Enum, decl);
            if array_find(V4L2_MACRO_ENUM_FLAG_TYPES, decl.name) {
                print("Making % enum_flags\n", decl.name);
                e.flags |= .IS_ENUM_FLAGS;
            }
        }
    }

    return .RECURSE;
}

// @Cleanup!
get_enum_name :: (argument_name: string, parent_name: string) -> string {
    if argument_name == {
        case "type";
            if parent_name == {
                case "v4l2_format";  return "v4l2_buf_type";
                // case "v4l2_input";   return "V4L2_INPUT_TYPE"; // This was generated from macro so doesn't have it's type set, would need more work.
                case "v4l2_requestbuffers"; return "v4l2_buf_type";
                case "v4l2_buffer"; return "v4l2_buf_type";
                case "v4l2_fmtdesc"; return "v4l2_buf_type";
            }

        case "field";
            if parent_name == {
                case "v4l2_pix_format";  return "v4l2_field";
            }
    }

    if parent_name ==  {
        case "v4l2_pix_format";
            if argument_name == {
                case "colorspace";    return "v4l2_colorspace";
                // case "flags";  return "V4L2_PIX_FMT_FLAG";
                case "quantization";  return "v4l2_quantization";
                case "xfer_func";     return "v4l2_xfer_func";
            }


        case "v4l2_buffer"; #through;
        case "v4l2_requestbuffers";
            if argument_name == {
                case "memory";    return "v4l2_memory";
            }
    }

    return "";
}


#if AT_COMPILE_TIME {
    #run,stallable {
        set_build_options_dc(.{do_output=false});
        root_options := get_build_options();
        args := root_options.compile_time_command_line;
        if !generate(args) {
            compiler_set_workspace_status(.FAILED);
        }
    }
} else {
    #import "System";

    main :: () {
        set_working_directory(path_strip_filename(get_path_of_running_executable()));
        args := get_command_line_arguments();
        if !generate(args) {
            exit(1);
        }
    }
}

#import "Basic";
#import "PI_Toolchain";
using,except(get_libc_paths) BG :: #import "Bindings_Generator";
#import "Compiler";
#import "File";
#import "File_Utilities";
#import "String";

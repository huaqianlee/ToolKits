#!/bin/bash
##
# @file gen_cscope_ctags.sh
# @brief to generate ctags and cscope easily and make the source directory clean.
#        Use ":cscope add <output_dir>" to add database for vim index.
# @author Andy Lee <huaqianlee@gmai.com>
# @version 0.1 
# @date 2023-04-08
#
# @copyright Copyright (c) 2023
#

# set -x

msg ()
{
    echo "MSG:$(date): $*"
}

usage ()
{
    echo "Usage: ${who_am_I} [-c | -k | -f | -a] -i <input_dir> -o <output_dir>"
    echo
    echo "Options:"
    echo "  -h, --help    show this message"
    echo "  -c            Generate for c,cpp projects"
    echo "  -k            Generate for kernel"
    echo "  -f            Generate for common files, such as python, c/c++, etc."
    echo "  -a            Generate for all files, not really all."
    echo "  -i            Specify the input directory, can not be relative path"
    echo "  -o            Specify where the built db output"
    exit 0
}

who_am_I="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
c_cc_files=(.cc .hh .h .c .cpp Makefile Kconfig .conf .bb .bbclass CMakeLists.txt)
kernel_files=(${c_cc_files[@]} dts dtsi)
common_files=(.pl .xml .py .cc .hh .h .c .cpp .sh)
all_files=(.pl .xml .py .cc .hh .h .c .cpp .sh .java  Makefile Kconfig .conf .bb .bbclass CMakeLists.txt)

parse_cmdline_parameter()
{
    while [ $# -gt 0  ]; do
        case $1 in
            "-h" | "--help")
                usage
                shift
                ;;
            "-c")
                file_types=${c_cc_files[@]}
                shift
                ;;
            "-k")
                file_types=${kernel_files[@]}
                is_kernel="-k"
                shift
                ;;
            "-f")
                file_types=${common_files[@]}
                shift
                ;;
            "-a")
                file_types=${all_files[@]}
                shift
                ;;
            "-i")
                input_dir=$2
                if [ "/" != ${input_dir:0:1} ]; then
                    input_dir=$(cd ${input_dir}; pwd)
                    cd -
                fi
                shift
                shift
                ;;
            "-o")
                output_dir=$2
                if [ ! -d ${output_dir} ]; then
                    mkdir -p ${output_dir}
                fi
                shift
                shift
                ;;
            *)
                ;;
        esac
    done
}

get_the_files ()
{
    for file_type in ${file_types[@]}; do
        the_cmd_string="find "
        the_cmd_string+=${input_dir}
        the_cmd_string+=" "
        #
        # Warping file_type with '' takes a lot errors here, Double quotes 
        # (or no quotes at all) are necessary for variable expansion, 
        # Single quotes will not work.
        # 
        # "-o -name "$file_type" doesn't work correctly on my Mac, since I am a new comer
        # for Mac, currently use the lower efficiency way which find by loop. The better
        # way should be:
        #   find <input_dir> -name .cc -o -name .c ... -o out_dir
        #
        the_cmd_string+="-name \"*$file_type\"" 
        #the_cmd_string+='" 2&>/dev/null | tee cscope_ctags.files"'
        the_cmd_string+=" >> cscope_ctags.files"
        echo ${the_cmd_string}
        eval ${the_cmd_string}
    done
    sort cscope_ctags.files > cscope_ctags.files.sorted
    mv cscope_ctags.files.sorted cscope_ctags.files
}

build_cscope_ctags ()
{
    cscope ${is_kernel} -R -q -b -i cscope_ctags.files
    ctags -R -L cscope_ctags.files
}

main ()
{
    if [ 0 -eq $# ]; then
        usage
    fi

    parse_cmdline_parameter $*
    #echo ${file_types[@]}
    get_the_files

    if [ -n "$output_dir" ]; then
        mv cscope_ctags.files ${output_dir}/
        cd $output_dir
        build_cscope_ctags
        cd -
    else
        build_cscope_ctags
    fi
}
main $*

import subprocess
import sys

def compile_slang_to_hlsl(slangc_path, slang_file, hlsl_file):
    # 使用slangc编译slang文件到hlsl
    slangc_command = [slangc_path, slang_file, "-o", hlsl_file, "-target", "hlsl"]
    subprocess.run(slangc_command, check=True)

def compile_hlsl_with_dxc(dxc_path, hlsl_file, output_file):
    # 使用dxc编译hlsl文件并输出日志
    dxc_command = [dxc_path, "-T", "ps_6_0", "-E", "main", "-Fc", output_file, hlsl_file]
    subprocess.run(dxc_command, check=True)

def main():
    if len(sys.argv) != 4:
        print("Usage: python3 compile.py <slang_file> <hlsl_file> <output_file>")
        return

    slangc_path = "D:\\packman-repo\\chk\\slang\\2023.5.0\\bin\\windows-x64\\release\\slangc"
    dxc_path = "D:\\packman-repo\\chk\\dxcompiler\\1.7.2207\\bin\\x64\\dxc"
    slang_file = sys.argv[1]
    hlsl_file = sys.argv[2]
    output_file = sys.argv[3]

    compile_slang_to_hlsl(slangc_path, slang_file, hlsl_file)
    compile_hlsl_with_dxc(dxc_path, hlsl_file, output_file)

if __name__ == "__main__":
    main()
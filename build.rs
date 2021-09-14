use std::env;

const FLAGS: &[&str] = &[
    "-I@ROOT@/lib/mswu",
    "-I@ROOT@/include",
    "-D__WXMSW__",
    "-DwxDEBUG_LEVEL=0",
    "-L@ROOT@/lib",
    "-lwxmsw31u",
    "-lkernel32",
    "-luser32",
    "-lgdi32",
    "-lcomdlg32",
    "-lwinspool",
    "-lwinmm",
    "-lshell32",
    "-lshlwapi",
    "-lcomctl32",
    "-lole32",
    "-loleaut32",
    "-luuid",
    "-lrpcrt4",
    "-ladvapi32",
    "-lversion",
    "-lws2_32",
    "-lwininet",
    "-loleacc",
    "-luxtheme",
    "-lwxregexu",
    "-lws2_32",
    "-lwinhttp",
    "-lwxjpeg",
    "-lwxpng",
    "-lwxtiff",
    "-lwxzlib",
    "-lwinmm",
    "-lwxscintilla",
    "-limm32",
    "-lwxexpat",
    "-lopengl32",
    "-lglu32",
];

fn main() {
    let pkg_path = env::var("CARGO_MANIFEST_DIR").unwrap();
    let flags = FLAGS
        .iter()
        .map(|&f| f.replace("@ROOT@", &pkg_path).replace('\n', " "))
        .collect::<Vec<_>>();

    println!("cargo:cflags={}", flags.join(" "));
}

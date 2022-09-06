use std::env;

include!(concat!(env!("OUT_DIR"), "/flags.rs"));

pub fn wx_config(args: &[&str]) -> Vec<String> {
    let flags = FLAGS.split_whitespace().map(ToOwned::to_owned);
    let (ldflags, cflags): (Vec<_>, Vec<_>) =
        flags.partition(|f| f.starts_with("-l") || f.starts_with("-L"));
    if args.contains(&"--cflags") {
        cflags
    } else {
        ldflags
    }
}

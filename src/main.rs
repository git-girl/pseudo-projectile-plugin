use std::env;
use std::process::{Command, Stdio};
// use std::path::Path;
// use std::sync::mpsc;
// use std::thread;
// use std::time::Duration;

fn main() {
    let opts: Options = parse_opts();
    project_open();
}

#[derive(Debug)]
struct Options {
    editor: Command,
    size: i32,
    help: bool,
    nogit: bool,
}

fn parse_opts() -> Options {
    // WARNING: this doesnt handle the whole $1 arg  handling with the opts -1 -q $1
    let mut opts = Options {
        editor: Command::new("nvim"),
        size: 10,
        help: false,
        nogit: false,
    };

    let args: Vec<String> = env::args().collect();

    for i in 0..args.len() {
        let arg = &args[i];
                                     
        match arg.as_str() {
            "--editor" => opts.editor = Command::new(&args[i + 1].as_str()),
            "--size" => opts.size = args[i + 1].parse::<i32>().unwrap(),
            "--nogit" => opts.nogit = true,
            "--help" => print_help(),
            _ => println!("BAD OPT")
        }
    }

    println!("Chosen Editor: {:?}", opts);
    return opts; }

fn print_help() {
    println!("Pseudo-Projectile-Plugin");
    println!();
    println!("use project_open to jump to a project directory");
    println!("--editor ARG : open editor after in project directory");
    println!("--size ARG : display fzf selection prompt (as percentage)");
    println!("--nogit : disable git support");
    println!();
    println!("use project_add to add a project to your project directory");

    std::process::exit(0);
}


fn project_open() -> i32 {
    let start_dir = std::env::current_dir().unwrap();
    // println!("{:?}", start_dir);

    // TODO: support opt handling -> do i use geopt -> no zparseopts cuz dependencies
    let find = Command::new("find")
        .arg("-L")
        .arg("/home/cherry-cat/projects")
        .arg("-maxdepth")
        .arg("1")
        .arg("-print")
        .stdout(Stdio::piped())
        .spawn()
        .expect("failed on find");

    let find_res = find.stdout.expect("Failed to open echo stdout");

    let fzf = Command::new("fzf")
        .arg("--no-multi")
        .arg("--height")
        .arg("10")
        .stdin(Stdio::from(find_res))
        .stdout(Stdio::piped())
        .spawn()
        .expect("failed on fzf");

    // returns Vec<u8>
    let fzf_result = fzf.wait_with_output().expect("getting project from fzf failed");
    let mut cd_path = String::from_utf8(fzf_result.stdout).unwrap();
    cd_path.truncate(cd_path.len() - 1); // NOTE: Remove the newline char from path
    // cd_path = cd_path.into_os_string();

    println!("CD_PATH: {}", cd_path);

    // std::env::set_current_dir(&cd_path).expect("Unable to change into [path to executable]/nvs");

    // let cd = Command::new("cd")
    //     .arg(cd_path)
    //     .spawn()
    //     .expect("failed on cd to dir selected with fzf.. weird");

    return 0;
}

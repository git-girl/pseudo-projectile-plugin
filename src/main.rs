use std::{env, process::{Command, Stdio}};
use std::thread;
use crate::thread::sleep;
use std::time::Duration;

// use std::path::Path;
// use std::sync::mpsc;
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
            _ => () // unit thingy is nil return
            // _ =>  println!("BAD OPT")
        }
    }

    // println!("Chosen Editor: {:?}", opts);
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
    // WARNING: this can panic -> if no input then subtract with overflow -> be careful need a
    // check here
    cd_path.truncate(cd_path.len() - 1); // Remove the newline char from path

    let cd_path_copy = cd_path.clone();
    thread::spawn(move || { // Intentional detached thread
        git_fetch(cd_path_copy.clone());
    });

    sleep(Duration::from_millis(25));
    // NOTE: retuns cd_path to std out 
    println!("{}", cd_path);
    return 0;
}

// WARNING: Doens't work if i have the function be asynchronous
fn git_fetch(path: String) { 
    // NOTE: might send stuff to null instead of stdout

    // command has available fields stdin stdout stderr
    let fzf = Command::new("git")
        .arg("fetch")
        .arg(path)
        .spawn()
        .expect("failed on git fetch");

    // println!("{:?}", fzf.stdout);

    let notify = Command::new("notify-send")
        .arg("PPP: Git Report")
        .arg("there")
        .spawn()
        .expect("couldnt send notification regarding git");

    // println!("Return stuff from fetch");
    // println!("{}", path)
}

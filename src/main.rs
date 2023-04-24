use crate::thread::sleep;
use std::str::FromStr;
use std::thread;
use std::time::Duration;
use std::{
    env,
    io::{self, Write},
    process::{Command, Stdio},
};

// TODO: consider using this binding rather then libc crate dependency
// use std::os::unix::thread::JoinHandleExt;
use libc::pthread_exit;
use std::mem;
use std::os::raw::c_void;
// use std::path::Path;
// use std::sync::mpsc;
// use std::time::Duration;

fn main() {
    let opts: Options = parse_opts();

    match opts.command {
        PPPCommand::GetProjectPath => {
            let cd_path = get_project_path();
            println!("{}", cd_path);
        }

        PPPCommand::GitCheck => {
            git_check();
        }
    }
}

#[derive(Debug)]
enum PPPCommand {
    GetProjectPath,
    GitCheck,
}

impl FromStr for PPPCommand {
    type Err = ();
    fn from_str(input: &str) -> Result<PPPCommand, Self::Err> {
        match input {
            "GetProjectPath" => Ok(PPPCommand::GetProjectPath),
            "GitCheck" => Ok(PPPCommand::GitCheck),
            _ => Err(()),
        }
    }
}

#[derive(Debug)]
struct Options {
    command: PPPCommand,
    editor: Command,
    size: i32,
    help: bool,
    nogit: bool,
}

fn parse_opts() -> Options {
    // WARNING: this doesnt handle the whole $1 arg  handling with the opts -1 -q $1
    let mut opts = Options {
        command: PPPCommand::GetProjectPath,
        editor: Command::new("nvim"),
        size: 10,
        help: false,
        nogit: false,
    };

    let args: Vec<String> = env::args().collect();

    for i in 0..args.len() {
        let arg = &args[i];

        if i < args.len() - 1 {
            // BUG: breaks if --command ..  but no args
            match arg.as_str() {
                // TODO: COMMAND OPT PARSING INTO ENUM
                "--command" => opts.command = PPPCommand::from_str(&args[i + 1].as_str()).expect("failed parsing PPPCommand opt"),
                "--editor" => opts.editor = Command::new(&args[i + 1].as_str()),
                "--size" => opts.size = args[i + 1].parse::<i32>().unwrap(),
                "--nogit" => opts.nogit = true,
                "--help" => print_help(),
                _ => (), // unit thingy is nil return
                         // _ =>  println!("BAD OPT")
            }
        }
    }

    // println!("Chosen Editor: {:?}", opts);
    return opts;
}

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

fn get_project_path() -> String {
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
    let fzf_result = fzf
        .wait_with_output()
        .expect("getting project from fzf failed");
    let mut cd_path = String::from_utf8(fzf_result.stdout)
        .expect("failed transforming fzf input -> probably no path given");

    if cd_path.len() >= 1 {
        cd_path.truncate(cd_path.len() - 1); // Remove the newline char from path
    } else {
        eprintln!("failed transforming fzf input -> probably no path given");
        std::process::exit(0);
    }

    cd_path
}
fn git_check() {
    let git_fetch = Command::new("git")
        .arg("fetch")
        .output()
        .expect("failed on starting git fetch");

    let git_diff = Command::new("git")
        .arg("diff")
        .arg("HEAD")
        .arg("@{u}")
        .arg("--name-only")
        .output()
        .expect("failed starting git diff");

    let notify = Command::new("notify-send")
        .arg("PPP: started git fetch")
        .spawn()
        .expect("couldnt start notify-send");

    unsafe {
        // TODO: Somewhere here
        // FATAL: exception not rethrown
        // [1]    2217618 IOT instruction (core dumped)  ./target/debug/pseudo-projectile
        let retval: *mut c_void = libc::malloc(mem::size_of::<c_void>()) as *mut c_void;
        // i can get a print until here  which is good :)

        pthread_exit(retval); // WARNING: Is this a memory leak? i make a pointer and don't
                              // deallocated memory :s
    }
}

fn project_open() {
    let start_dir = std::env::current_dir().unwrap();

    let cd_path = get_project_path();

    let git_fetch = Command::new("git")
        .arg("fetch")
        .stdin(Stdio::piped())
        .spawn()
        .expect("failed on starting git fetch");

    let git_diff = Command::new("git")
        .arg("diff")
        .arg("HEAD")
        .arg("@{u}")
        .arg("--name-only")
        .spawn()
        .expect("failed starting git diff");

    let notify = Command::new("notify-send")
        .arg("PPP: started git fetch")
        .spawn()
        .expect("couldnt start notify-send");

    // QUESTION: why is this timeout being set?
    // let zload = Command::new("exec")
    //     .arg("zmodload")
    //     .arg("zsh/zselect")
    //     .spawn()
    //     .expect("failed on starting zload");
    //
    // let _zload_process = zload.stdin.expect("L136");
    //
    // let zselect = Command::new("zselect")
    //     .arg("-t")
    //     .arg("500")
    //     // .stdin(Stdio::from(zload_process))
    //     .spawn()
    //     .expect("failed on starting zselect settint timeout");
    // let zselect_process = zselect.stdout.expect("L145");

    let _notify = Command::new("notify-send")
        .arg("PPP: Git Report")
        .arg("TODO...  thread comms")
        // .stdin(Stdio::from(zselect_process))
        .spawn()
        .expect("couldnt start notify-send");

    // println!("{}", cd_path);
    // NOTE: exit process so that other threads aren't terminated
    // -> unix only windows has other syntax
    unsafe {
        // TODO: Somewhere here
        // FATAL: exception not rethrown
        // [1]    2217618 IOT instruction (core dumped)  ./target/debug/pseudo-projectile
        let retval: *mut c_void = libc::malloc(mem::size_of::<c_void>()) as *mut c_void;
        pthread_exit(retval); // WARNING: Is this a memory leak? i make a pointer and don't
                              // deallocated memory :s
    }
    // return 0;
}

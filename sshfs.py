#!/usr/bin/env python3
import subprocess
import pexpect
import os
import sys
import pyfiglet

SSH_SERVERS = [
    "acts-slc6-2",
    "atpc001"
]

SSHFS_SERVERS = [
    ("acts-slc6-2", "/home/pagessin", None),
    ("atpc001", "/atlas/scratch0/pagessin", None),
    # ("lxplus", "/afs/cern.ch/user/p/pagessin", os.path.expanduser("~/mnt/afs"))
]

KEYCHAIN_LOOKUP = [
    "atpc001"
]

def keychain_lookup(item):
    output = subprocess.check_output(["/usr/bin/security", "find-internet-password", "-s", item, "-w"]).decode("utf-8")
    return output

f = pyfiglet.Figlet()
print(f.renderText('SSH(FS)'))

def do_sshfs(server, path, pwd, mnt = None):
    mnt = mnt or os.path.expanduser(os.path.join("~", "mnt", server))
    # force unmount
    subprocess.call(["umount", "-f", mnt])

    cmd = ["sshfs", "{}:{}".format(server, path), mnt, "-o", "follow_symlinks", "-o", "volname={}".format(server)]
    if pwd is not None:
        cmd += ["-o", "password_stdin"]
        print(" ".join(cmd))
        subprocess.run(cmd, input=pwd.encode("utf-8"))
    else:
        print(" ".join(cmd))
        subprocess.run(cmd)

procs = []

def do_ssh(server, pwd):

    cmd = ["ssh", server, "-N"]
    if pwd is not None:
        cmd = ["sshpass"] + cmd
        print(" ".join(cmd))
        # p = subprocess.Popen(cmd, stdin=subprocess.PIPE)
        # p.stdin.write(pwd.encode("utf-8"))
        # procs.append(p)
    else:
        print(" ".join(cmd))
        # p = subprocess.Popen(cmd)
        # procs.append(p)





for server in SSH_SERVERS:
    pwd = None
    if server in KEYCHAIN_LOOKUP:
        pwd = keychain_lookup(server)
        assert len(pwd) > 0 and pwd != ""

    do_ssh(server, pwd)

for server, remote_path, local_path in SSHFS_SERVERS:
    pwd = None
    if server in KEYCHAIN_LOOKUP:
        pwd = keychain_lookup(server)
        assert len(pwd) > 0 and pwd != ""

    do_sshfs(server, remote_path, pwd, local_path)

try:
    for p in procs:
        p.wait()
except KeyboardInterrupt:
    print("terminating")
    for p in procs:
        p.terminate()
        p.wait()
    print("done")



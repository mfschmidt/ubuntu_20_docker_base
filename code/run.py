#!/usr/bin/env python3

import os
import pwd
import datetime
import subprocess


out_file = "/data/file_from_docker.txt"

if os.path.isfile(out_file):
    file_stat = os.stat(out_file)
    pwuid = pwd.getpwuid(file_stat.st_uid)
    print("'{}'' exists already and is owned by {} ({}:{})".format(
        out_file, pwuid.pw_name, pwuid.pw_uid, pwuid.pw_gid,
    ))
else:
    with open(out_file, "w") as f:
        f.write("{} : {}\n".format(
            datetime.datetime.now(),
            os.getcwd(),
        ))
        f.write(
            subprocess.run(
                ["ls", "-lart", "/data/", ],
                stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                check=True, text=True
            ).stdout
        )


print("I am {} ({}:{})".format(
    pwd.getpwuid(os.getuid()).pw_name, os.getuid(), os.getgid()
))

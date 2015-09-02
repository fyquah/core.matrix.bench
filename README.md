# core.matrix Benchmark Scripts

A collection of scripts to benchmark [core.matrix](
    https://github.com/mikera/core.matrix).

More concretely, this program spawns an AWS Ubuntu 14.04 cloud instance, prepare
the environment (insalling Java, lein etc.) and run the core.matrix benchmarks,
which are defined in the `clojure.core.matrix.docgen.bench` namespace ([here](https://github.com/mikera/core.matrix/blob/develop/src/dev/clojure/clojure/core/matrix/docgen/bench.clj)).

There are several configuration options (instance type, SSH keys and bucket name).

## Example

Working on it.

## Dependencies

* awk version 20070501
* perl v5.18.2
* GNU Make 3.81

Clojure / Java is not included in the dependency list as you'd not require it
on the machine running this Makefile. It is required in the instance running
the test bench, but the script will handle the relevant installations.

## Usage

Firstly, you will have to configure the following environment variables in your
shell startup files (eg: `zshrc` for zsh, `bashrc` for bash).

The access key must belong to a user who can:

* Create EC2 instances
* Create S3 buckets

~~~bash
export AWS_ACCESS_KEY_ID='AWS_ACCESS_KEY_ID'
export AWS_SECRET_ACCESS_KEY='AWS_SECRET_ACCESS_KEY'
export AWS_DEFAULT_REGION='AWS_DEFAULT_REGION'
~~~

Then, you may start running the various make scripts.

~~~bash
cd /path/to/bench/mark/repo

# 1. Configure the ssh keys, instance types and bucket name
make configure

# 2. (Optional) If you want to benchmark your results in a public domain, run
# the following
make public

# 3. Run the benchmark! This will generate a file called instance.json
# It contains the output of running aws ec2 run-instances
# That json file is not used in any of the scripts
make

# 4. When the benchmark finishes, you can view it easily by: (Assuming it is public)
make view
~~~

## Configuration

| Option                |  Description              |
| --------------------- | ------------------------- |
| Instance type         | The type of instance. Refer [here](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-types.html) for more information about the type of instances available. Note: If you are benchmarking a GPU implementation, you'd need to spawn an instance which supports GPU.  |
| Key Pair              | A pre-configured SSH key pair in AWS S3 for you to access the instance should the need arises |
| Bucket name           | The name of the bucket where the information is stored |

## Testing

This script has been tested on a Darwin machine.

## Todos

* Some way to track the progress of the benchmark (a way to "tail" the standard
output and standard error of the script)
* A better access key management scheme (AWS specifically discourages
    the usage of permanent keys)
* A better way to manage configurations. Right now, instance-type, key pair and
bucket names are stored in `.txt` files. (I am comfortable with that, but there just
might be a better way.)
* Rewrite perl scripts in awk (Some Unix distros (eg: FreeBSD) do not ship perl)
* Rewrite the scripts to be `sh`-friendly, so that it runs happily on distros like FreeBSD. Right now it is only bash friendly.

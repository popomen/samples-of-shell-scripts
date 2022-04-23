#!/bin/bash

sub_proc() {
	while true; do
		sleep 1
		echo "[sub process $1] exec command \"env | grep NAN\" got $(env | grep NAN)"
	done
}

graceful_exit() {
	echo "start graceful exit"

	if [ $sub_proc_a_pid ]; then
		echo "killing sub_proc_a_pid=$sub_proc_a_pid"
		kill -SIGTERM $sub_proc_a_pid
	fi
	if [ $sub_proc_b_pid ]; then
		echo "killing sub_proc_b_pid=$sub_proc_b_pid"
		kill -SIGTERM $sub_proc_b_pid
	fi

	echo "exiting..."
	exit 0
}

trap graceful_exit SIGTERM
trap graceful_exit SIGINT

sub_proc a &
sub_proc_a_pid=$!

count=0

while (($count < 10)); do
	count=$(expr $count + 1)
	echo "[main process] is waiting" "$count"

	if [ $count == 5 ]; then
		echo "[main process] exec\"export NAN=1\""
		export NAN=1
		echo "[main process] exec\"env | grep NAN\""
		env | grep NAN

		sub_proc b &
		sub_proc_b_pid=$!
	fi

	sleep 1
done

graceful_exit


# View CPU info
cat /proc/cpuinfo

# Lists hardware in a compact format
sudo lshw -short
# Lists all disks and storage controllers in the system
sudo lshw -class disk -class storage

# Check what type of disk is mounted
# You should get 1 for hard disks and 0 for a SSD.
cat /sys/block/sda/queue/rotational
cat /sys/block/sdb/queue/rotational

# Another cmd to check what type of disk is mounted
lsblk -d -o name, rota

# Test disk read
sudo hdparm -t /dev/sdb

# Could also try: https://github.com/phoronix-test-suite/phoronix-test-suite

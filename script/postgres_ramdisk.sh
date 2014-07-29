# https://gist.github.com/dnagir/1573414
# 560mb ramdisk

diskutil erasevolume HFS+ "postgres_ramdisk" `hdiutil attach -nomount ram://1165430`
sudo chown -R $(whoami) /Volumes/postgres_ramdisk
dropdb opencounter_test
psql -c "create tablespace opencounter_ramdisk location '/Volumes/postgres_ramdisk';"
psql -c "create database opencounter_test tablespace = opencounter_ramdisk;"
rake db:test:load

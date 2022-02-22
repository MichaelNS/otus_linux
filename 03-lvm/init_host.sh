vagrant up

vagrant scp ./scripts/01_move_root_to_temp_volume.sh 01_move_root_to_temp_volume.sh
vagrant scp ./scripts/02_move_root_to_reduced_volume_create_mirrored_home.sh 02_move_root_to_reduced_volume_create_mirrored_home.sh
vagrant scp ./scripts/03_create_snapshot_of_home.sh 03_create_snapshot_of_home.sh

vagrant ssh


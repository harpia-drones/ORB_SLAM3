ORBSLAM3_ROOT_DIR="$(pwd)"

sudo apt-get update
sudo apt-get install -y libgl1-mesa-dev libglew-dev libeigen3-dev

cd "${ORBSLAM3_ROOT_DIR}/Vocabulary"
tar -xf ORBvoc.txt.tar.gz ORBvoc.txt
echo "export ORB_VOC_PATH='$ORBSLAM3_ROOT_DIR/Vocabulary/ORBvoc.txt'" >> ~/.bashrc

cd "${ORBSLAM3_ROOT_DIR}/Thirdparty/DBoW2"
mkdir -p build
cd build
cmake ..
make
sudo make install

cd "${ORBSLAM3_ROOT_DIR}/Thirdparty/g2o"
mkdir -p build
cd build
cmake ..
make
sudo make install

cd "${ORBSLAM3_ROOT_DIR}/Thirdparty/Sophus"
mkdir -p build
cd build
cmake ..
sudo make install

cd "${ORBSLAM3_ROOT_DIR}/Thirdparty/Pangolin"
mkdir -p build && cd build
cmake .. -DCMAKE_POSITION_INDEPENDENT_CODE=ON
make
sudo make install

cd "${ORBSLAM3_ROOT_DIR}"
mkdir -p build && cd build
cmake .. -DPANGOLIN_BUILD_SHARED=ON
make
sudo make install

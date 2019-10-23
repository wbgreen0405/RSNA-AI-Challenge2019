set -ex
model=model003
gpu=1
fold=2
conf=./conf/${model}.py

#python -m src.cnn.main train ${conf} --fold ${fold} --gpu ${gpu}

ep=1
tta=5
clip=1e-6

snapshot=./model/${model}/fold${fold}_ep${ep}.pt
valid=./model/${model}/fold${fold}_ep${ep}_valid_tta${tta}.pkl
test=./model/${model}/fold${fold}_ep${ep}_test_tta${tta}.pkl
sub=./data/submission/${model}_fold${fold}_ep${ep}_test_tta${tta}.csv

python -m src.cnn.main test ${conf} --snapshot ${snapshot} --output ${test} --n-tta ${tta} --fold ${fold} --gpu ${gpu}
python -m src.postprocess.make_submission --input ${test} --output ${sub} --clip ${clip}
#kaggle competitions submit rsna-intracranial-hemorrhage-detection -m "se resnet101 on v100" -f ${sub}
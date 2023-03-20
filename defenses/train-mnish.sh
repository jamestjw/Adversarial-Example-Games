modelnames=(modelA modelB modelC modelD)
modeltypes=(0 1 2 3)

for (( i=0; i<${#modeltypes[*]}; ++i)); do
    modelname="${modelnames[$i]}"
    modeltype="${modeltypes[$i]}"
    echo "Training for model: ${modelname} type: ${modeltype}"
    python ensemble_adver_train_mnist.py --model $modelname --type=$modeltype --namestr="" --batch_size=5096 --epsilon=0.3 --epochs=12
done

for (( i=0; i<${#modeltypes[*]}; ++i)); do
    modelname="${modelnames[$i]}"
    modeltype="${modeltypes[$i]}"
    echo "Training adv for model: ${modelname} type: ${modeltype}"
    python ensemble_adver_train_mnist.py --model "${modelname}_adv" --type=$modeltype --namestr="" --batch_size=5096 --epsilon=0.3 --adv_models --train_adv --epochs=12
done


python ensemble_adver_train_mnist.py --model modelA_ens --adv_models modelD modelC modelB --type=0 --epochs=12 --train_adv --namestr="" --epsilon=0.3  --batch_size=2600 
python ensemble_adver_train_mnist.py --model modelB_ens --adv_models modelA modelC modelD --type=1 --epochs=12 --train_adv --namestr="" --epsilon=0.3  --batch_size=2600 
python ensemble_adver_train_mnist.py --model modelC_ens --adv_models modelA modelD modelB --type=2 --epochs=12 --train_adv --namestr="" --epsilon=0.3  --batch_size=2600 
python ensemble_adver_train_mnist.py --model modelD_ens --adv_models modelA modelC modelB --type=3 --epochs=12 --train_adv --namestr="" --epsilon=0.3  --batch_size=2600 
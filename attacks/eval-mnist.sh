modelnames=(modelA modelB modelC modelD)
modeltypes=(0 1 2 3)

for (( i=0; i<${#modeltypes[*]}; ++i)); do
    modelname="${modelnames[$i]}"
    modeltype="${modeltypes[$i]}"
    echo "Eval for model: ${modelname} type: ${modeltype}"
    python no_box_attack.py --dataset mnist --perturb_loss Linf --epsilon=0.3 --attack_ball Linf --test_batch_size 64 --model CondGen --command eval --source_arch natural2 --model_name $modelname --type $modeltype --transfer --save_model "${modelname}-pgd-critic-test-natural-normal-gen" --dir_test_models ../ --target_arch natural
done
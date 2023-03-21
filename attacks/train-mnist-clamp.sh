modelnames=(modelA modelB modelC modelD)
modeltypes=(0 1 2 3)

for (( i=0; i<${#modeltypes[*]}; ++i)); do
    modelname="${modelnames[$i]}"
    modeltype="${modeltypes[$i]}"
    echo "Training MNIST for model: ${modelname} type: ${modeltype} with clamp generator"

    python no_box_attack.py --dataset mnist --namestr="${modelname} Mnist eps=0.3 Extragradient PGD-Critic=True Lambda=10 Training-set=test Gen=clamp Non-ensemble" --perturb_loss Linf --epsilon=0.3 --attack_ball Linf --batch_size 2600 --test_batch_size 64 --attack_epochs 150 --extragradient --lr 1e-3 --lr_model 1e-3 --max_iter 20 --attack_loss cross_entropy --model MnistGeneratorClamp --command train --source_arch natural2 --model_name $modelname --type $modeltype --eval_freq 2 --transfer --lambda_on_clean 10 --save_model "${modelname}-pgd-critic-test-natural-clamp-gen" --dir_test_models ../ --pgd_on_critic --train_set test --target_arch natural --wandb --filter_test_regex "\w+_ens"
done
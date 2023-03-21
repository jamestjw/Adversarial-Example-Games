modelnames=(modelA modelB modelD modelC)
modeltypes=(0 1 3 2)
N=(100 1000 5000)

for (( i=0; i<${#modeltypes[*]}; ++i)); do
    modelname="${modelnames[$i]}"
    modeltype="${modeltypes[$i]}"
    for n in "${N[@]}"
    do
        echo "Training for model: ${modelname} type: ${modeltype} on subset: ${n} of training data"
        savemodel="${modelname}-pgd-critic-test-natural-normal-gen-subset-${n}"

        python no_box_attack.py --dataset mnist --namestr="${modelname} Mnist eps=0.3 Extragradient PGD-Critic=True Lambda=10 Training-set=test Gen=normal Non-ensemble Subset:${n}" --perturb_loss Linf --epsilon=0.3 --attack_ball Linf --batch_size 2600 --test_batch_size 64 --attack_epochs 150 --extragradient --lr 1e-3 --lr_model 1e-3 --max_iter 20 --attack_loss cross_entropy --model CondGen --command train --source_arch natural2 --model_name $modelname --type $modeltype --eval_freq 2 --transfer --lambda_on_clean 10 --save_model $savemodel --dir_test_models ../ --pgd_on_critic --train_set test --target_arch natural --num_test_samples $n --fixed_testset --wandb --seed 42
    done
done
# Populate pretrained models
```bash
# In the defenses directory
python ensemble_adver_train_mnist.py --model modelA --type=0 --namestr=""
python ensemble_adver_train_mnist.py --model modelB --type=1 --namestr=""
python ensemble_adver_train_mnist.py --model modelC --type=2 --namestr=""
python ensemble_adver_train_mnist.py --model modelD --type=3 --namestr=""

python ensemble_adver_train_mnist.py --model modelA_ens --adv_models modelD modelC modelB --type=0 --epochs=12 --train_adv --namestr=""
python ensemble_adver_train_mnist.py --model modelB_ens --adv_models modelA modelC modelD --type=1 --epochs=12 --train_adv --namestr=""
python ensemble_adver_train_mnist.py --model modelC_ens --adv_models modelA modelD modelB --type=2 --epochs=12 --train_adv --namestr=""
python ensemble_adver_train_mnist.py --model modelD_ens --adv_models modelA modelC modelB --type=3 --epochs=12 --train_adv --namestr=""
```

# NoBox training
Trying to train a single model without ensemble, passing in `source_arch = ens_adv` is weird, but after examining the code this seems to do what I want it to do. Model name is the name of the critic, and model is the generator architecture.
```bash
# In the attacks directory
python no_box_attack.py --dataset mnist --namestr="A Mnist eps=0.3 Extragradient PGD-Critic=False Lambda=10" --perturb_loss Linf --epsilon=0.3 --attack_ball Linf --batch_size 1024 --test_batch_size 64 --attack_epochs 150 --extragradient --lr 1e-3 --lr_model 1e-3 --max_iter 20 --attack_loss cross_entropy --model CondGen --num_test_samples 256 --command train --source_arch ens_adv --model_name modelA --type 0 --eval_freq 2 --transfer --lambda_on_clean 10 --save_model "modelA" --dir_test_models ../ --adv_models modelA modelB modelC modelD  --wandb

python no_box_attack.py --dataset mnist --namestr="A Mnist eps=0.3 Extragradient PGD-Critic=True Lambda=10" --perturb_loss Linf --epsilon=0.3 --attack_ball Linf --batch_size 1024 --test_batch_size 64 --attack_epochs 150 --extragradient --lr 1e-3 --lr_model 1e-3 --max_iter 20 --attack_loss cross_entropy --model CondGen --num_test_samples 256 --command train --source_arch ens_adv --model_name modelA --type 0 --eval_freq 2 --transfer --lambda_on_clean 10 --save_model "modelA-pgd-critic" --dir_test_models ../ --adv_models modelA modelB modelC modelD modelA_ens modelB_ens modelC_ens modelD_ens --wandb --pgd_on_critic

python no_box_attack.py --dataset mnist --namestr="B Mnist eps=0.3 Extragradient PGD-Critic=True Lambda=10" --perturb_loss Linf --epsilon=0.3 --attack_ball Linf --batch_size 1024 --test_batch_size 64 --attack_epochs 15 --extragradient --lr 1e-3 --lr_model 1e-3 --max_iter 20 --attack_loss cross_entropy --model CondGen --num_test_samples 256 --command train --source_arch ens_adv --model_name modelB --type 1 --eval_freq 1 --transfer --lambda_on_clean 10 --save_model "modelB-pgd-critic" --dir_test_models ../ --adv_models modelA modelB modelC modelD modelA_ens modelB_ens modelC_ens modelD_ens --wandb --pgd_on_critic


# Test set training
python no_box_attack.py --dataset mnist --namestr="A Mnist eps=0.3 Extragradient PGD-Critic=True Lambda=10 Training-set=test" --perturb_loss Linf --epsilon=0.3 --attack_ball Linf --batch_size 1024 --test_batch_size 64 --attack_epochs 150 --extragradient --lr 1e-3 --lr_model 1e-3 --max_iter 20 --attack_loss cross_entropy --model CondGen --command train --source_arch ens_adv --model_name modelA --type 0 --eval_freq 2 --transfer --lambda_on_clean 10 --save_model "modelA-pgd-critic-test" --dir_test_models ../ --adv_models modelA modelB modelC modelD modelA_ens modelB_ens modelC_ens modelD_ens --wandb --pgd_on_critic --train_set test
```

# Notes
The perturb loss is the penalty of producing delta that would cause the pixel values to no longer be in 0 - 1.

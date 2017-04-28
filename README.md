# itamae lamp centos6

create lamp environment by itamae for cakephp3

## Requirement

- CentOS 6

## Usage

install gem.
```
bundle install --path vendor/bundle
```

run
```
bundle exec itamae ssh -i ~/.ssh/id_rsa_example_jp -u root -h host001.example.jp -y nodes/node.yml roles/default.rb
```

dry run
```
bundle exec itamae ssh -i ~/.ssh/id_rsa_example_jp -u root -h host001.example.jp -y nodes/node.yml roles/default.rb -n
```
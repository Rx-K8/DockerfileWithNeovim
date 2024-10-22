# 概要
dockerでGPUの環境を作成するためのスクリプトです．

## 注意事項
- ユーザディレクトリ（ホームディレクトリ）で実行しないでください．エラーが出るようにはしています．
- CreateContainer.sh と Dockerfileは同じディレクトリにおいてください．

## 使い方
```
$ bash CreateContainer.sh --cuda_version (cudaのバージョン) --share_dir (共有したいディレクトリの絶対パス) --name (コンテナの名前)

例1) $ bash CreateContainer.sh --cuda_version 12.1 --name practice1
例2) $ bash CreateContainer.sh --cuda_version 11.8 --share_dir ~/dock --name practice2
```

## オプション
### --cuda_version *必須
> [対応バージョン]  
>- 12.1(nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04)
>- 11.8(nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04)
>- 11.7(nvidia/cuda:11.7.1-cudnn8-devel-ubuntu22.04)
>- 11.6(nvidia/cuda:11.6.1-cudnn8-devel-ubuntu20.04)
>- 11.5(nvidia/cuda:11.5.2-cudnn8-devel-ubuntu20.04)
>- 11.4(nvidia/cuda:11.4.3-cudnn8-devel-ubuntu20.04)
>- 11.3(nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04)
>- 11.2(nvidia/cuda:11.2.2-cudnn8-devel-ubuntu20.04)
>- 11.1(nvidia/cuda:11.1.1-cudnn8-devel-ubuntu20.04)
>- 11.0(nvidia/cuda:11.0.3-cudnn8-devel-ubuntu20.04)

### --share_dir *省略可
> 共有したいディレクトリの絶対パスを指定してください．  
> 省略した場合は，カレントディレクトリが共有ディレクトリになります．

### --name *必須
> 好きなコンテナの名前をつけてください．  

## その他
- 初めて使う場合，イメージを作成するため，時間がかかります．2回目以降はイメージの作成が終わっているので，すぐに終わります．
- asdfを使ってpythonをインストールしているので，コンテナに入ってからpythonのバージョンを変更可能です．

# AnomalyCLIP チュートリアル (日本語)

このドキュメントでは，データセットの準備から学習，推論までの基本的な流れを日本語で説明します。

## 1. 環境構築

Python 3.8 以降と PyTorch 2.0.0 で動作確認されています。必要なライブラリは `requirements.txt` に記載されています。

```bash
pip install -r requirements.txt
```

## 2. データセットの準備

AnomalyCLIP では複数のデータセットをサポートしており，まずそれぞれのデータを取得する必要があります。代表的なデータセットは以下の通りです。

- **MVTec AD**: <https://www.mvtec.com/company/research/datasets/mvtec-ad>
- **VisA**: <https://github.com/amazon-science/spot-diff>
- そのほか MPDD，BTAD，SDD 等

ダウンロード後は次節で紹介する JSON 生成スクリプトを用いてデータセット情報を作成します。

### 2.1 データセット JSON の生成

`generate_dataset_json` ディレクトリに各データセット用のスクリプトが用意されています。例えば MVTec AD の場合，以下のように実行します。

```bash
cd generate_dataset_json
python mvtec.py
```

SDD のように異常カテゴリが 1 つのみのデータセットも同様です。

```bash
cd generate_dataset_json
python SDD.py
```

スクリプト実行後，データセット構造を記述した JSON ファイルが生成されます。このファイルを AnomalyCLIP が参照することで，各種データセットを正しく読み込むことができます。

## 3. 学習の実行

学習は `train.py` を使用します。サンプルのシェルスクリプト `train.sh` では VisA で学習する例を示しています。基本的なコマンドライン引数は以下の通りです。

```bash
python train.py \
    --dataset visa \
    --train_data_path /path/to/Visa \
    --save_path ./checkpoints/visa_model/ \
    --features_list 24 \
    --image_size 518 \
    --batch_size 8 \
    --epoch 15
```

学習済みモデルは `--save_path` で指定したディレクトリに保存されます。

## 4. 推論の実行

学習済みモデルを用いた推論は `test.py` で行います。`test.sh` には MVTec AD での推論例が記載されています。基本形は次の通りです。

```bash
python test.py \
    --dataset mvtec \
    --data_path /path/to/mvtec \
    --checkpoint_path ./checkpoints/visa_model/epoch_15.pth \
    --save_path ./results/zero_shot \
    --image_size 518
```

推論結果は `--save_path` で指定したディレクトリに保存されます。画像レベルの異常検知結果やヒートマップなどが確認できます。

## 5. Docker での利用 (任意)

Docker を用いた実行も可能です。まずリポジトリルートの `Dockerfile` からイメージをビルドします。

```bash
docker build -t anomalyclip .
```

GPU 環境で利用する場合は，以下のようにコンテナを起動し，必要に応じてデータセットをマウントします。

```bash
docker run --gpus all -it -v /path/to/dataset:/data anomalyclip
```

コンテナ内で前述の学習・推論コマンドを実行できます。

## 6. 参考資料

詳細な使用方法や追加のオプションについては，`README.md` を参照してください。



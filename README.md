# 駅くぐる

## デモ動画
[![デモ動画用サムネ](https://github.com/user-attachments/assets/9a501f21-0fbc-491d-a81f-819df84e0109)
](https://youtu.be/PAU-5mBOTMw?si=kv6wfif2_ViJLryt)

## 製品概要
この駅，トイレない...! ディジタルディバイドを取り除く未来のためのアプリ

### メンバー構成
* デポンテスマコト: 新技術開拓・フロントエンド・UI・PM担当
* 太田愛理: データベース・フロントエンド・バックエンド担当
* 橋本龍典: フロントエンド担当

### 開発背景
　今日，駅が抱える機能は日に日に増えていっています．私たちの県の誇る名古屋駅も，今はホテルやショッピングモール，オフィス等が軒を連ねる巨大な駅です．<br>
　しかし，一歩郊外の駅へと出ると，状況は大きく変わります．多くの人がぶつかるギャップは，恐らく皆さん共感できるものでしょう：

* トイレがない...！
* トイレが改札内にない...！
* 車いす対応トイレがない...！
* ICカードチャージ機がない...！

　例えばトイレがない駅を考えましょう．このような駅は，都市圏を外れれば全国に多く存在します．そして，ハンディキャップのある人にとって，トイレはあっても車いす対応トイレ等がないのは死活問題です．また，都市圏においても，トイレが改札外にしかないため，一回改札を出ないとトイレに行けない駅もあります．改札外のトイレに行くために改札を出て料金を払わなければならないなんて，嫌ですよね．僕たちは嫌です！<br>
　こうしたギャップはなぜ生まれるか．原因は，駅に何があるか，それを知る方法がないからです．こうした __ディジタルディバイド問題__ は，日本で現在大きな問題となっています．日本で生きる全ての人が幸せに暮らすためには，このディジタルディバイドは解消しなければなりません．<br>
　こうして，少しでも身近なディジタルディバイドを解消するためのアプリとして生まれたのが，駅情報共有アプリ「駅くぐる」です．
### 製品説明（具体的な製品の説明）
### 特長
#### 1. GoogleMap上にある駅情報を検索して、その駅に何があるかを地図から直感的に見ることが出来る
#### 2. 路線図や駅名から駅の設備を詳しく調べることも可能！
#### 3. 駅の設備であるか分からないものは、ユーザからのアンケートで可変的に登録可能！

### 解決出来ること
#### 1. 駅に降りたら○○がなかった、が解消される
#### 2. ハンディキャップのある人が対応トイレに悩まされることが軽減される
### 今後の展望
* 各設備の混雑度を分析して表示
* マップに表示されている複数の駅の設備情報を同時に表示
* マップの検索結果から駅詳細画面に遷移
### 注力したこと（こだわり等）
* GoogleMapと路線検索の両方を用意して，自身に合う方法で情報を検索できるようにしました．
* アンケート機能を実装し，データベースとの接続を用いて，情報が不足している設備をユーザーで作ることが出来るようにしました．

## 開発技術
### 活用した技術
#### API・データ
* Google Map API
* 鉄道各社様公式HPによる駅設備情報

#### フレームワーク・ライブラリ・モジュール
*Flutter
* firebase
* google_map_flutter
* geolocator

#### デバイス
* Android
* iOS

### 独自技術
#### ハッカソンで開発した独自機能・技術
* データベースとのやり取りを通じて，設備の情報(改札内か改札外か等)にたいしてユーザー側からアクセスできるようにしました
  ( https://github.com/jphacks/ng_2407/blob/main/lib/service/station_service.dart 内updateFacilityVote関数とhttps://github.com/jphacks/ng_2407/blob/main/lib/questionariePage.dart における処理)
* GoogleMapから駅を検索した際はピンを立て，そのピンのinfoWindowから設備情報が表示されるようにしました．また，DirectionAPIと連携し，GoogleMapに遷移して経路を表示したり，検索欄を押したらオートコンプリート付属の検索をして住所を入力したり，geolocatorを使用してユーザーの位置情報にマップの位置を揃えるようにも実装しました．
  (ピン・現在位置表示: https://github.com/jphacks/ng_2407/blob/main/lib/displayMap.dart 及び 検索機能: https://github.com/jphacks/ng_2407/blob/main/lib/move2Search.dart , https://github.com/jphacks/ng_2407/blob/main/lib/searchPage.dart)
* データベースとのやり取りにおいて，バッチ処理を適応することで処理速度をユーザーが不快に思わないものに抑えました．また，読み込みが必要ない部分だけ先に処理をし，読み込みが必要な部分をローディング中にすることでユーザーの体験が損なわれないように設計しました．
  (データベースとやりとりするサービス処理 https://github.com/jphacks/ng_2407/blob/main/lib/service/station_service.dart )
* シンプルなデザインに注力をし，ユーザーが説明なしでも直感的に使いやすいようにアプリのUIをデザインしました．

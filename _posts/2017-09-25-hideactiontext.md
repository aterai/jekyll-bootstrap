---
layout: post
category: swing
folder: HideActionText
title: JButtonのテキストとしてActionの名前を適用しないよう設定する
tags: [JButton, AbstractButton, Action]
author: aterai
pubdate: 2017-09-25T13:00:27+09:00
description: JButtonにActionを設定したとき、そのアクション名をJButtonのテキストとして適用しないよう設定します。
image: https://drive.google.com/uc?id=0ByeXYahiJNmHa2J2Q0xkT013OTA
comments: true
---
## 概要
`JButton`に`Action`を設定したとき、そのアクション名を`JButton`のテキストとして適用しないよう設定します。

{% download https://drive.google.com/uc?id=0ByeXYahiJNmHa2J2Q0xkT013OTA %}

## サンプルコード
<pre class="prettyprint"><code>button.setHideActionText(false);
</code></pre>

## 解説
上記のサンプルでは、`JButton#setHideActionText(false)`を設定した状態で`Action`を変更した場合などのテストを行っています。

- `JButton#setHideActionText(false)`を設定した状態で`Action`を変更した場合、そのアクション名やアイコンなどは`JButton`に適用されない
    - `JButton.setText(...)`、`JButton.setIcon(...)`の設定が残る
- `JButton#setHideActionText(false)`を設定した状態でも`Action`を`null`(初期状態)に変更すると、`JButton`のテキストやアイコンはクリアされてしまう
- アクションから名前とアイコンが適用された状態から、`JButton#setHideActionText(false)`を実行した場合、`JButton`のテキストはクリアされるが、アイコンは変化しない
    - `JButton.setText(...)`、`JButton.setIcon(...)`で設定している場合も同様に、`JButton`のテキストはクリアされるが、アイコンは変化しない
- `JButton#setHideActionText(...)`の状態に`JButton.setText(...)`、`JButton.setIcon(...)`は完全に依存しない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [AbstractButton#setHideActionText(boolean) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/AbstractButton.html#setHideActionText-boolean-)

<!-- dummy comment line for breaking list -->

## コメント

---
layout: post
category: swing
folder: RolloverModeToolBar
title: JToolBarのロールオーバー状態を設定する
tags: [JToolBar, JToggleButton, AbstractButton, Focus]
author: aterai
pubdate: 2017-08-07T14:35:07+09:00
description: JToolBarのロールオーバー状態を設定し、内部に設定したJToggleButtonなどの表示を変更します。
image: https://drive.google.com/uc?id=10xjTu8RF7AgkHSL9kzraWAKN5bmfcUON0A
comments: true
---
## 概要
`JToolBar`のロールオーバー状態を設定し、内部に設定した`JToggleButton`などの表示を変更します。

{% download https://drive.google.com/uc?id=10xjTu8RF7AgkHSL9kzraWAKN5bmfcUON0A %}

## サンプルコード
<pre class="prettyprint"><code>JToolBar toolbar = new JToolBar();
// System.out.println(toolbar.isRollover());
toolbar.setRollover(true);
</code></pre>

## 解説
- `JToolBar#setRollover(true)`
    - ロールオーバーが有効になる
    - この設定は`LookAndFeel`の実装に依存し、無視される場合がある
        - 例えば`NimbusLookAndFeel`は常にロールオーバーが有効
        - `WindowsLookAndFeel`の初期状態では、`JToolBar#isRollover()`メソッドは`false`を返すのに動作は`true`を設定した場合と同じになる
    - `JToggleButton`自体に`AbstractButton#setRolloverEnabled(false)`を設定してもロールオーバー表示が実行される
    - `LookAndFeel`依存の描画で`JToggleButton`に`AbstractButton#setContentAreaFilled(false)`を設定するとボタンが選択されているか判別不可になる場合がある
- `JToolBar#setRollover(false)`
    - ロールオーバーは無効になる
    - `WindowsLookAndFeel`では`JToggleButton`のフチが`BevelBorder`に変更される

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JToolBar#setRollover(boolean) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JToolBar.html#setRollover-boolean-)

<!-- dummy comment line for breaking list -->

## コメント

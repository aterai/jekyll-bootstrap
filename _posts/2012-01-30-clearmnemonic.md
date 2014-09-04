---
layout: post
title: MnemonicをクリアしてJButtonを初期状態に戻す
category: swing
folder: ClearMnemonic
tags: [JButton, Mnemonic]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-01-30

## 概要
`JButton`に設定された`Mnemonic`をクリアして初期状態に戻します。

{% download https://lh4.googleusercontent.com/-VBCuKbB3hhs/TyZJM3aWNzI/AAAAAAAABIg/01Dscav-qV4/s800/ClearMnemonic.png %}

## サンプルコード
<pre class="prettyprint"><code>button.setMnemonic(0);
</code></pre>

## 解説
- `setMnemonic(...)`
    - `JTextField`の最初の文字を`JButton`の`Mnemonic`に設定
    - `JTextField`が空の場合は、`JButton`のラベルの先頭文字を`Mnemonic`に設定

<!-- dummy comment line for breaking list -->

- `clear Mnemonic`
    - `Mnemonic`に`0`を設定して初期状態に戻す
    - `button.setMnemonic(0);`

<!-- dummy comment line for breaking list -->

## コメント

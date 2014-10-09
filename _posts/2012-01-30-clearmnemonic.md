---
layout: post
category: swing
folder: ClearMnemonic
title: MnemonicをクリアしてJButtonを初期状態に戻す
tags: [JButton, Mnemonic]
author: aterai
pubdate: 2012-01-30T16:49:29+09:00
description: JButtonに設定されたMnemonicをクリアして初期状態に戻します。
comments: true
---
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

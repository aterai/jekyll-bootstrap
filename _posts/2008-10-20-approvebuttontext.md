---
layout: post
category: swing
folder: ApproveButtonText
title: JFileChooserのボタンテキストを変更
tags: [JFileChooser, UIManager, Mnemonic]
author: aterai
pubdate: 2008-10-20T14:22:27+09:00
description: JFileChooserのボタンテキストを変更します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTHw6_sLrI/AAAAAAAAARs/5fsN5G2p15U/s800/ApproveButtonText.png
comments: true
---
## 概要
`JFileChooser`のボタンテキストを変更します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTHw6_sLrI/AAAAAAAAARs/5fsN5G2p15U/s800/ApproveButtonText.png %}

## サンプルコード
<pre class="prettyprint"><code>//UIManager.put("FileChooser.saveButtonText",   "保存(S)");
//UIManager.put("FileChooser.openButtonText",   "開く(O)");
UIManager.put("FileChooser.cancelButtonText", "キャンセル");

JFileChooser fileChooser = new JFileChooser();
//fileChooser.setApproveButtonText("開く(O)");
//fileChooser.setApproveButtonMnemonic('O');
</code></pre>

## 解説
上記のサンプルは、日本語の`WindowsLookAndFeel`に合わせて`JFileChooser`の`ApproveButton`やキャンセルボタンのテキストを以下のように変更しています。

- ~~`OpenDialog`のデフォルトでは、ファイルリストでフォルダが選択された状態の場合「開く(`O`)」、ファイルが選択された状態の場合「開く」に切り替わる~~
    - ~~この切り替えでボタンサイズが変化しないように、両方「開く(`O`)」に揃える~~
- ~~`SaveDialog`のデフォルトでは、ファイルリストでフォルダが選択されていると「開く(`O`)」、ファイルが選択されていると「保存」なので、「保存(`S`)」に揃える~~
    - `CancelButton`のデフォルトは、「取消し」で`SaveDialog`のフォルダ・ファイルの選択が切り替わるとボタンサイズに合わせてレイアウトが変化してしまうので、これを防ぐために二文字分長い「キャンセル」に変更

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JFileChooser (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JFileChooser.html)

<!-- dummy comment line for breaking list -->

## コメント
- `Java 1.6.0_12`以降、デフォルトでは`Mnemonic`の表示がなくなっているようです(もしかしてバグ？)。 -- *aterai* 2009-10-09 (金) 20:01:14
    - メモ: [&#91;JDK-5045878&#93; &#91;ja&#93; extra mnemonic characters on control buttons in JFileChooser - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-5045878)でも、`1.6.0`は関係なさそう…。 -- *aterai* 2009-10-09 (金) 20:16:41
- `6u18`で復活: [&#91;JDK-6785462&#93; Missing "(O)" in JFileChooser Open button in Windows LAF - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-6785462) -- *aterai* 2010-06-14 (月) 02:28:39
- `6u27`で、日本語表示の場合などで`Mnemonic`の表示(「開く(`O`)」の(`O`)など)が無くなったみたいです: [&#91;JDK-7021445&#93; Localization needed on resource string for FileChooser Look and Feel code - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-7021445) -- *aterai* 2011-08-22 (月) 20:23:48
    - `1.7.0`は、「開く(`O`)」のまま。 -- *aterai* 2011-08-22 (月) 20:48:03

<!-- dummy comment line for breaking list -->

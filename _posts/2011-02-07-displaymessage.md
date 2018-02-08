---
layout: post
category: swing
folder: DisplayMessage
title: TrayIconのポップアップメッセージをテスト
tags: [TrayIcon, ActionListener]
author: aterai
pubdate: 2011-02-07T16:27:51+09:00
description: TrayIconのポップアップメッセージ表示をテストします。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TU-dbe20pkI/AAAAAAAAA0g/3fG2yE_NmHw/s800/DisplayMessage.png
comments: true
---
## 概要
`TrayIcon`のポップアップメッセージ表示をテストします。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TU-dbe20pkI/AAAAAAAAA0g/3fG2yE_NmHw/s800/DisplayMessage.png %}

## サンプルコード
<pre class="prettyprint"><code>//TrayIcon.MessageType: ERROR, WARNING, INFO, NONE
trayIcon.displayMessage("caption", "text text...", TrayIcon.MessageType.ERROR);
</code></pre>

## 解説
上記のサンプルでは、`TrayIcon.displayMessage(...)`メソッドを使用して、ポップアップメッセージを表示しています。

- メモ:
    - `TrayIcon`に`ActionListener`を追加しておくと、ポップアップメッセージのクリックイベントが取得できる
    - `Windows 10`で`TrayIcon.MessageType.NONE`を使用する場合、`TrayIcon#setImage(...)`がポップアップメッセージのアイコンとして表示されるが、`TrayIcon.setImageAutoSize(false)`でも自動的にリサイズされ、背景色は透過せず黒になる
    - [JDK-8146537 TrayIcon Action Listener doesnt work in WIndows 10 - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-8146537)
        - 修正中になっているが、`8u66`で修正されているらしい

<!-- dummy comment line for breaking list -->

## 参考リンク
- [TrayIcon#displayMessage(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/TrayIcon.html#displayMessage-java.lang.String-java.lang.String-java.awt.TrayIcon.MessageType-)

<!-- dummy comment line for breaking list -->

## コメント

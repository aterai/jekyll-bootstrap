---
layout: post
category: swing
folder: DisplayMessage
title: TrayIconのポップアップメッセージをテスト
tags: [TrayIcon, ActionListener]
author: aterai
pubdate: 2011-02-07T16:27:51+09:00
description: TrayIconのポップアップメッセージ表示をテストします。
comments: true
---
## 概要
`TrayIcon`のポップアップメッセージ表示をテストします。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TU-dbe20pkI/AAAAAAAAA0g/3fG2yE_NmHw/s800/DisplayMessage.png %}

## サンプルコード
<pre class="prettyprint"><code>trayIcon.displayMessage("caption", "text", TrayIcon.MessageType.ERROR);
</code></pre>

## 解説
上記のサンプルでは、`TrayIcon.displayMessage(...)`メソッドを使用して、ポップアップメッセージを表示しています。

- - - -
`TrayIcon`に`ActionListener`を追加しておくと、ポップアップメッセージのクリックイベントを取得することができます。

## コメント

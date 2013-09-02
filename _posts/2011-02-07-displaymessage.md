---
layout: post
title: TrayIconのポップアップメッセージをテスト
category: swing
folder: DisplayMessage
tags: [TrayIcon, ActionListener]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-02-07

## TrayIconのポップアップメッセージをテスト
`TrayIcon`のポップアップメッセージ表示をテストします。

- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/_9Z4BYR88imo/TU-dbe20pkI/AAAAAAAAA0g/3fG2yE_NmHw/s800/DisplayMessage.png)

### サンプルコード
<pre class="prettyprint"><code>trayIcon.displayMessage("caption", "text", TrayIcon.MessageType.ERROR);
</code></pre>

### 解説
上記のサンプルでは、`TrayIcon.displayMessage(...)`メソッドを使用して、ポップアップメッセージを表示しています。

- - - -
`TrayIcon`に`ActionListener`を追加しておくと、ポップアップメッセージのクリックイベントを取得することができます。

### コメント

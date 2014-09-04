---
layout: post
title: ToolTip表示の切り替え
category: swing
folder: ToolTipManager
tags: [ToolTipManager, JToolTip]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-05-10

## 概要
ツールチップ(ツールヒント)表示の有無を`ToolTipManager`で切り替えます。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTVq857V2I/AAAAAAAAAoA/yRQeWtxd-78/s800/ToolTipManager.png %}

## サンプルコード
<pre class="prettyprint"><code>ActionListener al = new ActionListener() {
  @Override public void actionPerformed(ActionEvent e) {
    ToolTipManager.sharedInstance().setEnabled(onRadio.isSelected());
  }
};
onRadio.addActionListener(al);
offRadio.addActionListener(al);
</code></pre>

## 解説
上記のサンプルでは、ボタンにツールチップを設定してあり、表示するかどうかを`ToolTipManager`を使って切り替えています。

`ToolTipManager`は、アプリケーション全体でのツールチップの表示時間、表示までの遅延時間などを設定することができます。

## コメント

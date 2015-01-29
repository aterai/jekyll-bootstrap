---
layout: post
category: swing
folder: EnabledAt
title: JTabbedPaneのタブを選択不可にする
tags: [JTabbedPane]
author: aterai
pubdate: 2004-07-26T06:10:38+09:00
description: JTabbedPaneのタブが選択できるかどうかを切り替えます。
comments: true
---
## 概要
`JTabbedPane`のタブが選択できるかどうかを切り替えます。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTMLdSGopI/AAAAAAAAAYw/aRU27uh4vuQ/s800/EnabledAt.png %}

## サンプルコード
<pre class="prettyprint"><code>checkbox.addItemListener(new ItemListener() {
  @Override public void itemStateChanged(ItemEvent e) {
    if (e.getStateChange() == ItemEvent.SELECTED) {
      tab.setEnabledAt(1, true);
    } else if (e.getStateChange() == ItemEvent.DESELECTED) {
      tab.setEnabledAt(1, false);
    }
  }
});
</code></pre>

## 解説
上記のサンプルでは、チェックボックスを使って詳細設定タブが選択できるかどうかを切り替えることができます。

タブが選択できるかどうかは、`JTabbedPane#setEnabledAt`メソッドで設定します。

## コメント

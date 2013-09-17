---
layout: post
title: JTabbedPaneのタブを選択不可にする
category: swing
folder: EnabledAt
tags: [JTabbedPane]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-07-26

## JTabbedPaneのタブを選択不可にする
`JTabbedPane`のタブが選択できるかどうかを切り替えます。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTMLdSGopI/AAAAAAAAAYw/aRU27uh4vuQ/s800/EnabledAt.png)

### サンプルコード
<pre class="prettyprint"><code>checkbox.addItemListener(new ItemListener() {
  @Override public void itemStateChanged(ItemEvent e) {
    if(e.getStateChange()==ItemEvent.SELECTED) {
      tab.setEnabledAt(1, true);
    }else if(e.getStateChange()==ItemEvent.DESELECTED) {
      tab.setEnabledAt(1, false);
    }
  }
});
</code></pre>

### 解説
上記のサンプルでは、チェックボックスを使って詳細設定タブが選択できるかどうかを切り替えることができます。

タブが選択できるかどうかは、`JTabbedPane#setEnabledAt`メソッドで設定します。

### コメント

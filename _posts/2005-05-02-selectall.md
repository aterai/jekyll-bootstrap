---
layout: post
title: JTextField内のテキストをすべて選択
category: swing
folder: SelectAll
tags: [JTextField, FocusListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-05-02

## JTextField内のテキストをすべて選択
フォーカスが`JTextField`に移動したとき、そのテキストがすべて選択された状態にします。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTSvQx8j-I/AAAAAAAAAjQ/iXgBbTGTGuw/s800/SelectAll.png %}

### サンプルコード
<pre class="prettyprint"><code>textfield.addFocusListener(new FocusAdapter() {
  @Override public void focusGained(FocusEvent e) {
    ((JTextComponent)e.getComponent()).selectAll();
  }
});
</code></pre>

### 解説
上記のサンプルでは、上の`JTextField`にフォーカスが移動したとき、`JTextComponent#selectAll()`メソッドを使って内部のテキストがすべて選択された状態になるようにしています。

### コメント

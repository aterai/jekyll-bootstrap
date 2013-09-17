---
layout: post
title: JSplitPaneを等分割する
category: swing
folder: DividerLocation
tags: [JSplitPane]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-06-28

## JSplitPaneを等分割する
`JSplitPane`のディバイダが中央にくるように設定します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTLR0Z5M_I/AAAAAAAAAXU/R6r6dvVJa9M/s800/DividerLocation.png)

### サンプルコード
<pre class="prettyprint"><code>EventQueue.invokeLater(new Runnable() {
  @Override public void run() {
    sp.setDividerLocation(0.5);
    //sp.setResizeWeight(0.5);
  }
});
</code></pre>

### 解説
上記のサンプルでは、`JSplitPane`のサイズが決まった後(例えば`JFrame#pack()`や、`JFrame#setSize(int,int)`などした後)で、`JSplitPane#setDividerLocation(0.5);`を使用し、ディバイダを中央に配置しています。

- `JSplitPane#setDividerLocation(double)`
    - ディバイダ自身の幅(`JSplitPane#getDividerSize()`)は含まれない
    - 内部では、切り捨てで`JSplitPane#setDividerLocation(int)`を使用: [JSplitPaneのDividerの位置を最大化後に変更する](http://terai.xrea.jp/Swing/DividerSplitRatio.html)

<!-- dummy comment line for breaking list -->

- - - -
`JSplitPane#setResizeWeight(double)`を使用し、`JSplitPane`内に配置したコンポーネント(`JScrollPane`)の余ったスペースの配分が同じになるようにして、ディバイダを中央に配置する方法もあります。

### 参考リンク
- [JSplitPaneのDividerの位置を最大化後に変更する](http://terai.xrea.jp/Swing/DividerSplitRatio.html)

<!-- dummy comment line for breaking list -->

### コメント

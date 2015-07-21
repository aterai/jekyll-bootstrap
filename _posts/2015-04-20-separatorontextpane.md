---
layout: post
category: swing
folder: SeparatorOnTextPane
title: JTextPaneにJSeparatorを追加する
tags: [JTextPane, HTMLEditorKit, HTMLDocument, JSeparator, JLabel, MatteBorder]
author: aterai
pubdate: 2015-04-20T00:00:12+09:00
description: JTextPaneにセパレータとして、hr要素やJSeparator、MatteBorderを設定したJLabelなどを追加します。
comments: true
---
## 概要
`JTextPane`にセパレータとして、`hr`要素や`JSeparator`、`MatteBorder`を設定した`JLabel`などを追加します。

{% download https://lh3.googleusercontent.com/-DttSBuXmfOs/VTOx9lKJR2I/AAAAAAAAN2s/3ZCvhgC8QDw/s800/SeparatorOnTextPane.png %}

## サンプルコード
<pre class="prettyprint"><code>HTMLEditorKit kit = new HTMLEditorKit();
HTMLDocument doc = new HTMLDocument();
textPane.setEditorKit(kit);
textPane.setDocument(doc);
textPane.setEditable(false);
textPane.setText("&lt;html&gt;&amp;lt;hr&amp;gt;:&lt;hr /&gt;");

textPane.insertComponent(new JLabel("JSeparator: "));
textPane.insertComponent(new JSeparator(JSeparator.HORIZONTAL));
insertBR(kit, doc);

textPane.insertComponent(new JLabel("MatteBorder1: "));
textPane.insertComponent(new JLabel() {
  @Override public void updateUI() {
    super.updateUI();
    setBorder(BorderFactory.createMatteBorder(1, 0, 0, 0, Color.RED));
  }
  @Override public Dimension getMaximumSize() {
    return new Dimension(textPane.getSize().width, 1);
  }
});
insertBR(kit, doc);

textPane.insertComponent(new JLabel("MatteBorder2: "));
textPane.insertComponent(new JLabel() {
  @Override public void updateUI() {
    super.updateUI();
    setBorder(BorderFactory.createMatteBorder(1, 0, 0, 0, Color.GREEN));
  }
  @Override public Dimension getPreferredSize() {
    return new Dimension(textPane.getSize().width, 1);
  }
  @Override public Dimension getMaximumSize() {
    return this.getPreferredSize();
  }
});
insertBR(kit, doc);

textPane.insertComponent(new JLabel("JSeparator.VERTICAL "));
textPane.insertComponent(new JSeparator(JSeparator.VERTICAL) {
  @Override public Dimension getPreferredSize() {
    return new Dimension(1, 16);
  }
  @Override public Dimension getMaximumSize() {
    return this.getPreferredSize();
  }
});
textPane.insertComponent(new JLabel(" TEST"));
</code></pre>

## 解説
- `hr`要素
    - `htmlEditorKit.insertHTML(doc, doc.getLength(), "<hr />", 0, 0, null);`などで、`hr`要素を追加
- `JSeparator`
    - `textPane.insertComponent(new JSeparator(JSeparator.HORIZONTAL));`で水平`JSeparator`を追加
- `MatteBorder1`
    - `MatteBorder`を設定したテキスト無しの`JLabel`を追加
    - 最大サイズが(`JTextPane`の幅×`1`)になるよう、`JLabel#getMaximumSize()`をオーバーライド
- `MatteBorder2`
    - `MatteBorder`を設定したテキスト無しの`JLabel`を追加
    - 推奨サイズと最大サイズが(`JTextPane`の幅×`1`)になるよう、`JLabel#getPreferredSize()`と`JLabel#getMaximumSize()`をオーバーライド
- `JSeparator.VERTICAL`
    - `textPane.insertComponent(new JSeparator(JSeparator.VERTICAL));`で垂直`JSeparator`を追加
    - `JLabel#getPreferredSize()`、`JLabel#getMaximumSize()`をオーバーライドしないと表示されない？

<!-- dummy comment line for breaking list -->

## コメント
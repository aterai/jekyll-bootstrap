---
layout: post
category: swing
folder: AlignedLabel
title: JLabelの最大幅を共有して異なるパネル間で垂直位置を揃える
tags: [JLabel, JPanel, BoxLayout]
author: aterai
pubdate: 2018-02-19T16:26:52+09:00
description: JLabelの垂直位置を異なるパネル間でも揃えるため、最大幅のJLabelを検索してこれをすべての推奨サイズとして使用します。
image: https://drive.google.com/uc?id=1OYxUdKX7mxvEzkX5pjBjy2IFjYRLtfmKMw
comments: true
---
## 概要
`JLabel`の垂直位置を異なるパネル間でも揃えるため、最大幅の`JLabel`を検索してこれをすべての推奨サイズとして使用します。

{% download https://drive.google.com/uc?id=1OYxUdKX7mxvEzkX5pjBjy2IFjYRLtfmKMw %}

## サンプルコード
<pre class="prettyprint"><code>// @see javax/swing/plaf/metal/MetalFileChooserUI.java
class AlignedLabel extends JLabel {
  private static final int INDENT = 10;
  // private AlignedLabel[] group;
  protected List&lt;AlignedLabel&gt; group;
  protected int maxWidth;

  protected AlignedLabel(String text) {
    super(text);
    // setAlignmentX(JComponent.LEFT_ALIGNMENT);
    setHorizontalAlignment(SwingConstants.RIGHT);
  }
  @Override public Dimension getPreferredSize() {
    Dimension d = super.getPreferredSize();
    // Align the width with all other labels in group.
    return new Dimension(getMaxWidth() + INDENT, d.height);
  }
  private int getMaxWidth() {
    if (maxWidth == 0 &amp;&amp; group != null) {
      int max = group.stream()
        .map(AlignedLabel::getSuperPreferredWidth)
        .reduce(0, Integer::max);
      group.forEach(al -&gt; al.maxWidth = max);
    }
    return maxWidth;
  }
  private int getSuperPreferredWidth() {
    return super.getPreferredSize().width;
  }
  public static void groupLabels(List&lt;AlignedLabel&gt; group) {
    for (AlignedLabel al: group) {
      al.group = group;
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、`javax/swing/plaf/metal/MetalFileChooserUI.java`の`AlignedLabel`を参考に、異なるパネル間で`JLabel`の垂直位置揃えを行っています。

- `AlignedLabel`
    - `JLabel`を継承
    - `JLabel#getPreferredSize()`を垂直位置揃えを適用するラベルの中での最大幅を検索取得して返すようオーバーライド
- `BoxLayout`
    - `AlignedLabel`とその右に配置するコンポーネントを`Box.createHorizontalBox()`で作成した`Box`に追加
    - `FileChooser`と`HTTP Proxy`のタイトルを`TitledBorder`で設定した`Box`を`2`個作成し、上記の`AlignedLabel`を配置した`Box`をそれぞれ追加
    - 複数の`Box`に`AlignedLabel`が配置されていても、各`AlignedLabel`の推奨サイズの幅はすべて同じになっているため垂直位置は揃う

<!-- dummy comment line for breaking list -->

## 参考リンク
- [GroupLayoutの使用](https://ateraimemo.com/Swing/GroupLayout.html)
- [GridBagLayoutの使用](https://ateraimemo.com/Swing/GridBagLayout.html)
    - `1`つのパネル内で垂直位置揃えを行う場合は、`GroupLayout`や`GridBagLayout`が使用可能

<!-- dummy comment line for breaking list -->

## コメント

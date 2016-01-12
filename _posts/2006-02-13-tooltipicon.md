---
layout: post
category: swing
folder: ToolTipIcon
title: JToolTipにアイコンを表示
tags: [JToolTip, Icon, JLabel, Html, MatteBorder]
author: aterai
pubdate: 2006-02-13T14:40:55+09:00
description: JToolTipにJLabel、MatteBorder、またはHtmlタグを使用してアイコンを表示する方法をテストします。
comments: true
---
## 概要
`JToolTip`に`JLabel`、`MatteBorder`、または`Html`タグを使用してアイコンを表示する方法をテストします。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTVl25jXSI/AAAAAAAAAn4/-g0LJzeMmbc/s800/ToolTipIcon.png %}

## サンプルコード
<pre class="prettyprint"><code>JLabel l1 = new JLabel("JLabelを使ってツールチップにアイコン") {
  @Override public JToolTip createToolTip() {
    final JLabel iconlabel = new JLabel(icon);
    iconlabel.setBorder(BorderFactory.createEmptyBorder(1, 1, 1, 1));
    LookAndFeel.installColorsAndFont(
        iconlabel, "ToolTip.background", "ToolTip.foreground", "ToolTip.font");
    JToolTip tip = new JToolTip() {
      @Override public Dimension getPreferredSize() {
        //https://community.oracle.com/thread/2199222
        return getLayout().preferredLayoutSize(this);
      }
      @Override public void setTipText(final String tipText) {
        String oldValue = iconlabel.getText();
        iconlabel.setText(tipText);
        firePropertyChange("tiptext", oldValue, tipText);
      }
    };
    tip.setComponent(this);
    tip.setLayout(new BorderLayout());
    tip.add(iconlabel);
    return tip;
  }
};
l1.setToolTipText("Test1");
</code></pre>
<pre class="prettyprint"><code>JLabel l2 = new JLabel("MatteBorderでツールチップにアイコン") {
  @Override public JToolTip createToolTip() {
    JToolTip tip = new JToolTip() {
      @Override public Dimension getPreferredSize() {
        Dimension d = super.getPreferredSize();
        Insets i = getInsets();
        d.height = Math.max(d.height, icon.getIconHeight() + i.top + i.bottom);
        return d;
      }
    };
    tip.setComponent(this);
    Border b1 = tip.getBorder();
    Border b2 = BorderFactory.createMatteBorder(0, icon.getIconWidth(), 0, 0, icon);
    Border b3 = BorderFactory.createEmptyBorder(1, 1, 1, 1);
    Border b4 = BorderFactory.createCompoundBorder(b3, b2);
    tip.setBorder(BorderFactory.createCompoundBorder(b1, b4));
    return tip;
  }
};
l2.setToolTipText("Test2");
</code></pre>
<pre class="prettyprint"><code>JLabel l3 = new JLabel("htmlタグでツールチップにアイコン");
l3.setToolTipText("&lt;html&gt;&lt;img src='" + url + "'&gt;テスト&lt;/img&gt;&lt;/html&gt;");
</code></pre>

## 解説
- 上
    - `JToolTip`にアイコンを設定した`JLabel`を追加
- 中
    - アイコンを表示する`MatteBorder`を`JToolTip`に設定するよう、`createToolTip`メソッドをオーバーライド
- 下
    - `html`の`img`タグを`setToolTipText`メソッドに使用してアイコンを表示

<!-- dummy comment line for breaking list -->

## 参考リンク
- [XP Style Icons - Windows Application Icon, Software XP Icons](http://www.icongalore.com/)
    - アイコンを利用しています。
- [Swing - Using text and a progress bar inside of a tooltip.](https://community.oracle.com/thread/2199222)

<!-- dummy comment line for breaking list -->

## コメント
- `MatteBorder`を使うと`Java 1.4`と`1.5`で表示が微妙に異なるようです。 -- *aterai* 2006-02-13 (月) 14:57:57
- `JLabel`を`JToolTip`に貼る方法を追加しました。 -- *aterai* 2006-07-05 (水) 18:40:54
- 「`MatteBorder`でツールチップにアイコン」で、`MatteBorder`と`EmptyBorder`の内外が反対になっていたのを修正しました。 -- *aterai* 2006-07-05 (水) 19:15:11

<!-- dummy comment line for breaking list -->

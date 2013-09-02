---
layout: post
title: JToolTipにアイコンを表示
category: swing
folder: ToolTipIcon
tags: [JToolTip, Icon, JLabel, Html, MatteBorder]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-02-13

## JToolTipにアイコンを表示
`JToolTip`にアイコンを表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh3.ggpht.com/_9Z4BYR88imo/TQTVl25jXSI/AAAAAAAAAn4/-g0LJzeMmbc/s800/ToolTipIcon.png)

### サンプルコード
<pre class="prettyprint"><code>JLabel l1 = new JLabel("JLabelを使ってツールチップにアイコン") {
  @Override public JToolTip createToolTip() {
    final JLabel iconlabel = new JLabel(icon);
    iconlabel.setBorder(BorderFactory.createEmptyBorder(1,1,1,1));
    LookAndFeel.installColorsAndFont(
        iconlabel, "ToolTip.background", "ToolTip.foreground", "ToolTip.font");
    JToolTip tip = new JToolTip() {
      @Override public Dimension getPreferredSize() {
        //http://forums.oracle.com/forums/thread.jspa?threadID=2197222
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
        d.height = Math.max(d.height, icon.getIconHeight()+i.top+i.bottom);
        return d;
      }
    };
    tip.setComponent(this);
    Border b1 = tip.getBorder();
    Border b2 = BorderFactory.createMatteBorder(0, icon.getIconWidth(), 0, 0, icon);
    Border b3 = BorderFactory.createEmptyBorder(1,1,1,1);
    Border b4 = BorderFactory.createCompoundBorder(b3, b2);
    tip.setBorder(BorderFactory.createCompoundBorder(b1, b4));
    return tip;
  }
};
l2.setToolTipText("Test2");
</code></pre>
<pre class="prettyprint"><code>JLabel l3 = new JLabel("htmlタグでツールチップにアイコン");
l3.setToolTipText("&lt;html&gt;&lt;img src='"+url+"'&gt;テスト&lt;/img&gt;&lt;/html&gt;");
</code></pre>

### 解説
- 上ラベル
    - `JToolTip`に`JLabel`を追加しています。
- 中ラベル
    - `MatteBorder`を使ってアイコンを表示するように、`createToolTip`メソッドをオーバーライドしています。
- 下ラベル
    - `html`の`img`タグを`setToolTipText`メソッドに使ってアイコンを表示しています。

<!-- dummy comment line for breaking list -->

### 参考リンク
- [XP Style Icons - Windows Application Icon, Software XP Icons](http://www.icongalore.com/)
    - アイコンを利用しています。

<!-- dummy comment line for breaking list -->

### コメント
- `MatteBorder`を使うと`Java 1.4`と`1.5`で表示が微妙に異なるようです。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-02-13 (月) 14:57:57
- `JLabel`を`JToolTip`に貼る方法を追加しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-07-05 (水) 18:40:54
- 「`MatteBorder`でツールチップにアイコン」で、`MatteBorder`と`EmptyBorder`の内外が反対になっていたのを修正しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-07-05 (水) 19:15:11

<!-- dummy comment line for breaking list -->


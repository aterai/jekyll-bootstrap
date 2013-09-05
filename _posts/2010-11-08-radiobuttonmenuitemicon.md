---
layout: post
title: JRadioButtonMenuItemのチェックアイコンを変更する
category: swing
folder: RadioButtonMenuItemIcon
tags: [JRadioButtonMenuItem, Icon, UIManager]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-11-08

## JRadioButtonMenuItemのチェックアイコンを変更する
`JRadioButtonMenuItem`のチェックアイコンを変更します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh3.ggpht.com/_9Z4BYR88imo/TQTRVf_tDmI/AAAAAAAAAhA/1F6GcDuJmcg/s800/RadioButtonMenuItemIcon.png)

### サンプルコード
<pre class="prettyprint"><code>//com.sun.java.swing.plaf.windows.WindowsIconFactory.java
class RadioButtonMenuItemIcon1 implements Icon, UIResource, Serializable {
  @Override public void paintIcon(Component c, Graphics g, int x, int y) {
    AbstractButton b = (AbstractButton) c;
    ButtonModel model = b.getModel();
    if(b.isSelected()) {
      Graphics2D g2 = (Graphics2D)g;
      g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
      g2.fillRoundRect(x+3,y+3, getIconWidth()-6, getIconHeight()-6, 4, 4);
      g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_OFF);
    }
  }
  @Override public int getIconWidth()  { return 12; }
  @Override public int getIconHeight() { return 12; }
}
class RadioButtonMenuItemIcon2 implements Icon, UIResource, Serializable {
  @Override public void paintIcon(Component c, Graphics g, int x, int y) {
    AbstractButton b = (AbstractButton) c;
    ButtonModel model = b.getModel();
    if(b.isSelected()) {
      //g.fillRoundRect(x+3,y+3, getIconWidth()-6, getIconHeight()-6, 4, 4);
      g.fillOval(x+2,y+2, getIconWidth()-5, getIconHeight()-5);
      //g.fillArc(x+2,y+2,getIconWidth()-5, getIconHeight()-5, 0, 360);
    }
  }
  @Override public int getIconWidth()  { return 12; }
  @Override public int getIconHeight() { return 12; }
}
</code></pre>

### 解説
上記のサンプルでは、`WindowsLookAndFeel`(`Java1.6.0`)で、`JRadioButtonMenuItem`のチェックアイコンがすこし歪？なので以下のように修正しています。

- `default`
    - デフォルト
- `ANTIALIASING`
    - `com.sun.java.swing.plaf.windows.WindowsIconFactory`のアイコンを`g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)`でアンチエイリアス
- `fillOval`
    - `fillRoundRect`ではなく、`fillOval`を使用

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JCheckBoxMenuItemのチェックアイコンを変更する](http://terai.xrea.jp/Swing/CheckBoxMenuItemIcon.html)

<!-- dummy comment line for breaking list -->

### コメント
- `Windows 7`でテストするとアイコンの歪みはないようです。修正されてたのかも？ -- [aterai](http://terai.xrea.jp/aterai.html) 2012-08-08 (水) 19:51:09

<!-- dummy comment line for breaking list -->

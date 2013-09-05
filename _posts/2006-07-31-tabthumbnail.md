---
layout: post
title: JTabbedPaneのサムネイルをJToolTipで表示
category: swing
folder: TabThumbnail
tags: [JToolTip, JTabbedPane]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-07-31

## JTabbedPaneのサムネイルをJToolTipで表示
ツールチップを使って、`JTabbedPane`のサムネイルを表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTUz8_Yw-I/AAAAAAAAAmo/wLoOmG5I3oc/s800/TabThumbnail.png)

### サンプルコード
<pre class="prettyprint"><code>class MyTabbedPane extends JTabbedPane {
  private int current = -1;
  private static final double SCALE = 0.15d;
  private Component getTabThumbnail(int index) {
    Component c = getComponentAt(index);
    Icon icon = null;
    if(c instanceof JScrollPane) {
      c = ((JScrollPane)c).getViewport().getView();
      Dimension d = c.getPreferredSize();
      int newW = (int)(d.width  * SCALE);
      int newH = (int)(d.height * SCALE);
      BufferedImage image = new BufferedImage(newW, newH, BufferedImage.TYPE_INT_ARGB);
      Graphics2D g2 = (Graphics2D)image.getGraphics();
      g2.setRenderingHint(RenderingHints.KEY_INTERPOLATION,
                RenderingHints.VALUE_INTERPOLATION_BILINEAR);
      g2.scale(SCALE,SCALE);
      c.paint(g2);
      g2.dispose();
      icon = new ImageIcon(image);
    }else if(c instanceof JLabel) {
      icon = ((JLabel)c).getIcon();
    }
    return new JLabel(icon);
  }
  @Override public JToolTip createToolTip() {
    int index = current;
    if(index&lt;0) return null;
    final JPanel p = new JPanel(new BorderLayout());
    p.setBorder(BorderFactory.createEmptyBorder());
    p.add(new JLabel(getTitleAt(index)), BorderLayout.NORTH);
    p.add(getTabThumbnail(index));
    JToolTip tip = new JToolTip() {
      @Override public Dimension getPreferredSize() {
        Insets i = getInsets();
        Dimension d = p.getPreferredSize();
        return new Dimension(d.width+i.left+i.right,d.height+i.top+i.bottom);
      }
    };
    tip.setComponent(this);
    LookAndFeel.installColorsAndFont(
        p, "ToolTip.background", "ToolTip.foreground", "ToolTip.font");
    tip.setLayout(new BorderLayout());
    tip.add(p);
    return tip;
  }
  @Override public String getToolTipText(MouseEvent e) {
    int index = indexAtLocation(e.getX(), e.getY());
    String str = (current!=index)?null:super.getToolTipText(e);
    current = index;
    return str;
  }
}
</code></pre>

### 解説
マウスカーソルがタブタイトル上にきた場合、そのタブ内部のコンポーネントを縮小して`JToolTip`に貼り付けています。

### 参考リンク
- [デジタル出力工房　絵写楽](http://www.bekkoame.ne.jp/~bootan/free2.html)
- [2000ピクセル以上のフリー写真素材集](http://sozai-free.com/)
- [XP Style Icons - Windows Application Icon, Software XP Icons](http://www.icongalore.com/)

<!-- dummy comment line for breaking list -->

### コメント
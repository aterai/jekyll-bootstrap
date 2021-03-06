---
layout: post
category: swing
folder: CheckBoxMenuItemIcon
title: JCheckBoxMenuItemのチェックアイコンを変更する
tags: [JCheckBoxMenuItem, Icon, UIManager]
author: aterai
pubdate: 2009-09-14T14:19:06+09:00
description: JCheckBoxMenuItemのチェックアイコンを変更します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTI5TuivhI/AAAAAAAAATg/nfren8EjliA/s800/CheckBoxMenuItemIcon.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2009/10/jcheckboxmenuitem-icon.html
    lang: en
comments: true
---
## 概要
`JCheckBoxMenuItem`のチェックアイコンを変更します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTI5TuivhI/AAAAAAAAATg/nfren8EjliA/s800/CheckBoxMenuItemIcon.png %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("CheckBoxMenuItem.checkIcon", new Icon() {
  @Override public void paintIcon(Component c, Graphics g, int x, int y) {
    Graphics2D g2 = (Graphics2D) g.create();
    g2.translate(x, y);
    ButtonModel m = ((AbstractButton) c).getModel();
    g2.setPaint(m.isSelected() ? Color.ORANGE : Color.GRAY);
    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                        RenderingHints.VALUE_ANTIALIAS_ON);
    g2.fillOval(0, 2, 10, 10);
    g2.dispose();
  }

  @Override public int getIconWidth()  {
    return 14;
  }

  @Override public int getIconHeight() {
    return 14;
  }
});
menu.add(new JCheckBoxMenuItem("checkIcon test"));
</code></pre>

## 解説
- `JCheckBox`のチェックアイコンは、`JCheckBox#setIcon(Icon)`メソッドで変更可能
- `JCheckBoxMenuItem`はチェックアイコンとは別のアイコンが設定されているため、`setIcon(Icon)`メソッドではなく`UIManager.put("CheckBoxMenuItem.checkIcon", icon)`を使用する必要がある

<!-- dummy comment line for breaking list -->

- - - -
- `NimbusLookAndFeel`などで`JCheckBoxMenuItem`のチェックアイコンを変更する

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>import java.awt.*;
import java.awt.geom.*;
import javax.swing.*;
// JDK 1.6
import com.sun.java.swing.*;
import com.sun.java.swing.plaf.nimbus.*;
// JDK 1.7
// import javax.swing.plaf.nimbus.*;

class NimbusCheckIconTest {
  public JMenuBar createMenuBar() {
    JCheckBoxMenuItem cbmi = new JCheckBoxMenuItem("checkIcon test");
    UIDefaults d = new UIDefaults();
    d.put("CheckBoxMenuItem[Enabled].checkIconPainter",
          new MyCheckBoxMenuItemPainter(
            MyCheckBoxMenuItemPainter.CHECKICON_ENABLED));
    d.put("CheckBoxMenuItem[MouseOver].checkIconPainter",
          new MyCheckBoxMenuItemPainter(
            MyCheckBoxMenuItemPainter.CHECKICON_MOUSEOVER));
    d.put("CheckBoxMenuItem[Enabled+Selected].checkIconPainter",
          new MyCheckBoxMenuItemPainter(
            MyCheckBoxMenuItemPainter.CHECKICON_ENABLED_SELECTED));
    d.put("CheckBoxMenuItem[MouseOver+Selected].checkIconPainter",
          new MyCheckBoxMenuItemPainter(
            MyCheckBoxMenuItemPainter.CHECKICON_SELECTED_MOUSEOVER));
    cbmi.putClientProperty("Nimbus.Overrides", d);
    cbmi.putClientProperty("Nimbus.Overrides.InheritDefaults", false);
    JMenuBar menuBar = new JMenuBar();
    JMenu menu = new JMenu("A Menu");
    menuBar.add(menu);
    menu.add(new JCheckBoxMenuItem("default"));
    menu.add(cbmi);
    menuBar.add(menu);
    return menuBar;
  }
  public Container createContentPane() {
    JPanel contentPane = new JPanel(new BorderLayout());
    contentPane.setOpaque(true);
    contentPane.add(new JScrollPane(new JTextArea()));
    return contentPane;
  }
  private static void createAndShowGUI() {
    try {
      for (UIManager.LookAndFeelInfo laf: UIManager.getInstalledLookAndFeels())
        if ("Nimbus".equals(laf.getName()))
          UIManager.setLookAndFeel(laf.getClassName());
    } catch (Exception e) {
      e.printStackTrace();
    }
    NimbusCheckIconTest demo = new NimbusCheckIconTest();
    JFrame f = new JFrame();
    f.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
    f.setJMenuBar(demo.createMenuBar());
    f.setContentPane(demo.createContentPane());
    f.setSize(320, 240);
    f.setLocationRelativeTo(null);
    f.setVisible(true);
  }

  public static void main(String[] args) {
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        createAndShowGUI();
      }
    });
  }
}

// copy: CheckBoxMenuItemPainter.java
class MyCheckBoxMenuItemPainter extends AbstractRegionPainter {
  static final int CHECKICON_ENABLED_SELECTED   = 6;
  static final int CHECKICON_SELECTED_MOUSEOVER = 7;
  static final int CHECKICON_ENABLED            = 8;
  static final int CHECKICON_MOUSEOVER          = 9;
  private int state;
  private PaintContext ctx;
  public MyCheckBoxMenuItemPainter(int state) {
    super();
    this.state = state;
    this.ctx = new AbstractRegionPainter.PaintContext(
      new Insets(5, 5, 5, 5), new Dimension(9, 10), false, null, 1.0, 1.0);
  }

  @Override protected void doPaint(Graphics2D g, JComponent c,
                                   int width, int height, Object[] eckey) {
    switch (state) {
    case CHECKICON_ENABLED:
      paintcheckIconEnabled(g);
      break;
    case CHECKICON_MOUSEOVER:
      paintcheckIconMouseOver(g);
      break;
    case CHECKICON_ENABLED_SELECTED:
      paintcheckIconEnabledAndSelected(g);
      break;
    case CHECKICON_SELECTED_MOUSEOVER:
      paintcheckIconSelectedAndMouseOver(g);
      break;
    }
  }

  @Override protected final PaintContext getPaintContext() {
    return ctx;
  }

  private void paintcheckIconEnabled(Graphics2D g) {
    g.setPaint(Color.GREEN);
    g.drawOval(0, 0, 10, 10);
  }

  private void paintcheckIconMouseOver(Graphics2D g) {
    g.setPaint(Color.PINK);
    g.drawOval(0, 0, 10, 10);
  }

  private void paintcheckIconEnabledAndSelected(Graphics2D g) {
    g.setPaint(Color.ORANGE);
    g.fillOval(0, 0, 10, 10);
  }

  private void paintcheckIconSelectedAndMouseOver(Graphics2D g) {
    g.setPaint(Color.CYAN);
    g.fillOval(0, 0, 10, 10);
  }
}
</code></pre>

## 参考リンク
- [JCheckBoxMenuItem (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JCheckBoxMenuItem.html)
- [JRadioButtonMenuItemのチェックアイコンを変更する](https://ateraimemo.com/Swing/RadioButtonMenuItemIcon.html)

<!-- dummy comment line for breaking list -->

## コメント

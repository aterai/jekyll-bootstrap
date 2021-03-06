---
layout: post
category: swing
folder: MenuBarBackground
title: JMenuBarの背景に画像を表示する
tags: [JMenuBar, JMenu, JMenuItem, TexturePaint]
author: aterai
pubdate: 2009-08-10T15:27:32+09:00
description: JMenuが未選択状態の場合はその背景を透明にし、JMenuBarの背景に設定した画像を表示可能にします。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTPxQA13fI/AAAAAAAAAeg/SAN79wHPkQc/s800/MenuBarBackground.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2009/08/jmenubar-background-image.html
    lang: en
comments: true
---
## 概要
`JMenu`が未選択状態の場合はその背景を透明にし、`JMenuBar`の背景に設定した画像を表示可能にします。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTPxQA13fI/AAAAAAAAAeg/SAN79wHPkQc/s800/MenuBarBackground.png %}

## サンプルコード
<pre class="prettyprint"><code>public JMenuBar createMenubar() {
  final TexturePaint texture = makeTexturePaint();
  JMenuBar mb = new JMenuBar() {
    @Override protected void paintComponent(Graphics g) {
      super.paintComponent(g);
      Graphics2D g2 = (Graphics2D) g.create();
      g2.setPaint(texture);
      g2.fillRect(0, 0, getWidth(), getHeight());
      g2.dispose();
    }
  };
  mb.setOpaque(false);
  String[] menuKeys = {"File", "Edit", "Help"};
  for (String key: menuKeys) {
    JMenu m = createMenu(key);
    if (m != null) {
      mb.add(m);
    }
  }
  return mb;
}

private JMenu createMenu(String key) {
  JMenu menu = new JMenu(key) {
    @Override protected void fireStateChanged() {
      ButtonModel m = getModel();
      if (m.isPressed() &amp;&amp; m.isArmed()) {
        setOpaque(true);
      } else if (m.isSelected()) {
        setOpaque(true);
      } else if (isRolloverEnabled() &amp;&amp; m.isRollover()) {
        setOpaque(true);
      } else {
        setOpaque(false);
      }
      super.fireStateChanged();
    };
  };
  if ("Windows XP".equals(System.getProperty("os.name"))) {
    menu.setBackground(new Color(0x0, true)); // XXX: Windows XP lnf?
  }
  menu.add("dummy1"); menu.add("dummy2"); menu.add("dummy3");
  return menu;
}
</code></pre>

## 解説
上記のサンプルでは、`JMenuBar`に画像を描画し、これに追加する`JMenu`を通常は透明、選択されたときなどは不透明となるように`setOpaque`メソッドで切り替えています。

- `WindowsLookAndFeel`の場合、`JMenu#setBackground(new Color(0x0, true))`を設定する必要がある
- `WindowsLookAndFeel`に切り替えた直後のメニュー文字色などがおかしい？

<!-- dummy comment line for breaking list -->

- - - -
- `JFrame#setJMenuBar()`で追加した`JMenuBar`を透明にする場合のテスト

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>import java.awt.*;
import java.awt.image.*;
import java.util.Objects;
import javax.swing.*;
import javax.swing.plaf.*;

public class MenuBarRootPaneTest {
  private static final Color ALPHA_ZERO = new Color(0x0, true);
  private static final Color POPUP_BACK = new Color(0, 0, 0, 100);

  private static JMenuBar createMenuBar() {
    JMenuBar mb = new JMenuBar() {
        @Override public Dimension getPreferredSize() {
            Dimension d = super.getPreferredSize();
            d.height = 30;
            return d;
        }
    };
    mb.setBackground(POPUP_BACK);
    String[] menuKeys = {"File", "Edit", "Help"};
    for (String key : menuKeys) {
      mb.add(createMenu(key));
    }
    return mb;
  }

  private static JMenu createMenu(String key) {
    JMenu menu = new TransparentMenu(key);
    menu.add(new JMenuItem("dummy1"));
    menu.add(new JMenuItem("dummy2"));
    menu.add(new JMenuItem("dummy3"));
    return menu;
  }

  public static void main(String... args) {
    EventQueue.invokeLater(() -&gt; {
      UIManager.put("MenuBar.background", POPUP_BACK);
      UIManager.put("MenuBar.border",     BorderFactory.createEmptyBorder());
      UIManager.put("PopupMenu.border",   BorderFactory.createEmptyBorder());

      UIManager.put("Menu.foreground",              Color.WHITE);
      UIManager.put("Menu.background",              ALPHA_ZERO);
      UIManager.put("Menu.selectionBackground",     POPUP_BACK);
      UIManager.put("Menu.selectionForeground",     Color.WHITE);
      UIManager.put("Menu.borderPainted",           Boolean.FALSE);

      UIManager.put("MenuItem.foreground",          Color.WHITE);
      UIManager.put("MenuItem.background",          ALPHA_ZERO);
      UIManager.put("MenuItem.selectionBackground", POPUP_BACK);
      UIManager.put("MenuItem.selectionForeground", Color.WHITE);
      UIManager.put("MenuItem.borderPainted",       Boolean.FALSE);

      JFrame frame = new JFrame() {
        @Override protected JRootPane createRootPane() {
          return new JRootPane() {
            private final TexturePaint texture = makeTexturePaint();
            @Override protected void paintComponent(Graphics g) {
              super.paintComponent(g);
              Graphics2D g2 = (Graphics2D) g.create();
              g2.setPaint(texture);
              g2.fillRect(0, 0, getWidth(), getHeight());
              g2.dispose();
            }
            @Override public boolean isOpaque() {
              return true;
            }
          };
        }
      };
      frame.getRootPane().setBackground(Color.BLUE);
      frame.getLayeredPane().setBackground(Color.GREEN);
      frame.getContentPane().setBackground(Color.RED);
      ((JComponent) frame.getContentPane()).setOpaque(false);
      frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
      frame.setJMenuBar(createMenuBar());
      frame.setSize(320, 240);
      frame.setLocationRelativeTo(null);
      frame.setVisible(true);
    });
  }

  // TranslucentPopupMenu
  // https://ateraimemo.com/Swing/TranslucentPopupMenu.html
  static class TranslucentPopupMenu extends JPopupMenu {
    @Override public boolean isOpaque() {
      return false;
    }
    @Override public void show(Component c, int x, int y) {
      EventQueue.invokeLater(() -&gt; {
        Container p = getTopLevelAncestor();
        if (p instanceof JWindow) {
          System.out.println("Heavy weight");
          ((JWindow) p).setBackground(ALPHA_ZERO);
        }
      });
      super.show(c, x, y);
    }
    @Override protected void paintComponent(Graphics g) {
      Graphics2D g2 = (Graphics2D) g.create();
      g2.setPaint(POPUP_BACK);
      g2.fillRect(0, 0, getWidth(), getHeight());
      g2.dispose();
    }
  }

  static class TransparentMenu extends JMenu {
    private JPopupMenu popupMenu;

    protected TransparentMenu(String title) {
      super(title);
    }
    @Override public boolean isOpaque() {
      return false;
    }
    // Bug ID: JDK-4688783 JPopupMenu hardcoded i JMenu
    // https://bugs.openjdk.java.net/browse/JDK-4688783
    private void ensurePopupMenuCreated() {
      if (Objects.isNull(popupMenu)) {
        this.popupMenu = new TranslucentPopupMenu();
        popupMenu.setInvoker(this);
        popupListener = createWinListener(popupMenu);
      }
    }
    @Override public JPopupMenu getPopupMenu() {
      ensurePopupMenuCreated();
      return popupMenu;
    }
    @Override public JMenuItem add(JMenuItem menuItem) {
      ensurePopupMenuCreated();
      menuItem.setOpaque(false);
      return popupMenu.add(menuItem);
    }
    @Override public Component add(Component c) {
      ensurePopupMenuCreated();
      if (c instanceof JComponent) {
        ((JComponent) c).setOpaque(false);
      }
      popupMenu.add(c);
      return c;
    }
    @Override public void addSeparator() {
      ensurePopupMenuCreated();
      popupMenu.addSeparator();
    }
    @Override public void insert(String s, int pos) {
      if (pos &lt; 0) {
        throw new IllegalArgumentException("index less than zero.");
      }
      ensurePopupMenuCreated();
      popupMenu.insert(new JMenuItem(s), pos);
    }
    @Override public JMenuItem insert(JMenuItem mi, int pos) {
      if (pos &lt; 0) {
        throw new IllegalArgumentException("index less than zero.");
      }
      ensurePopupMenuCreated();
      popupMenu.insert(mi, pos);
      return mi;
    }
    @Override public void insertSeparator(int index) {
      if (index &lt; 0) {
        throw new IllegalArgumentException("index less than zero.");
      }
      ensurePopupMenuCreated();
      popupMenu.insert(new JPopupMenu.Separator(), index);
    }
    @Override public boolean isPopupMenuVisible() {
      ensurePopupMenuCreated();
      return popupMenu.isVisible();
    }
  }

  private static TexturePaint makeTexturePaint() {
    int cs = 6;
    int sz = cs * cs;
    BufferedImage img = new BufferedImage(sz, sz, BufferedImage.TYPE_INT_ARGB);
    Graphics2D g2 = img.createGraphics();
    g2.setPaint(new Color(222, 222, 222, 50));
    g2.fillRect(0, 0, sz, sz);
    for (int i = 0; i * cs &lt; sz; i++) {
      for (int j = 0; j * cs &lt; sz; j++) {
        if ((i + j) % 2 == 0) {
          g2.fillRect(i * cs, j * cs, cs, cs);
        }
      }
    }
    g2.dispose();
    return new TexturePaint(img, new Rectangle(sz, sz));
  }
}
// //https://ateraimemo.com/Swing/TranslucentPopupMenu.html
// class TranslucentPopupMenu extends JPopupMenu {
</code></pre>

## 参考リンク
- [AbstractButton#fireStateChanged() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/AbstractButton.html#fireStateChanged--)
- [JRootPaneの背景として画像を表示](https://ateraimemo.com/Swing/RootPaneBackground.html)

<!-- dummy comment line for breaking list -->

## コメント
- 選択状態を半透明にするテスト -- *aterai* 2010-01-09 (土) 23:08:42
    - `Windows7`での`WindowsLookAndFeel`でうまくいかない場合があるようなので、すこし修正。 -- *aterai* 2011-09-26 (月) 21:13:47
    - [JRootPaneの背景として画像を表示](https://ateraimemo.com/Swing/RootPaneBackground.html)に移動

<!-- dummy comment line for breaking list -->

---
layout: post
title: JMenuなどから開くPopupMenuを半透明化
category: swing
folder: TranslucentSubMenu
tags: [JMenu, JMenuItem, JPopupMenu, Translucent]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-10-22

## JMenuなどから開くPopupMenuを半透明化
`JPopupMenu`の親の`JWindow`、`JMenu`や`JMenuItem`などを透明にして、`JPopupMenu`を半透明にします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/-MKRZgWcSrRw/UIT3NRGfX9I/AAAAAAAABUk/fOYdfJmIt4g/s800/TranslucentSubMenu.png)

### サンプルコード
<pre class="prettyprint"><code>class TransparentMenu extends JMenu {
  public TransparentMenu(String title) {
    super(title);
  }
  //http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=4688783
  private JPopupMenu popupMenu;
  private void ensurePopupMenuCreated() {
    if(popupMenu == null) {
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
    if(c instanceof JComponent) {
      ((JComponent)c).setOpaque(false);
    }
    popupMenu.add(c);
    return c;
  }
  @Override public void addSeparator() {
    ensurePopupMenuCreated();
    popupMenu.addSeparator();
  }
  @Override public void insert(String s, int pos) {
    if(pos &lt; 0) {
      throw new IllegalArgumentException("index less than zero.");
    }
    ensurePopupMenuCreated();
    popupMenu.insert(new JMenuItem(s), pos);
  }
  @Override public JMenuItem insert(JMenuItem mi, int pos) {
    if(pos &lt; 0) {
      throw new IllegalArgumentException("index less than zero.");
    }
    ensurePopupMenuCreated();
    popupMenu.insert(mi, pos);
    return mi;
  }
  @Override public void insertSeparator(int index) {
    if(index &lt; 0) {
      throw new IllegalArgumentException("index less than zero.");
    }
    ensurePopupMenuCreated();
    popupMenu.insert( new JPopupMenu.Separator(), index );
  }
  @Override public boolean isPopupMenuVisible() {
    ensurePopupMenuCreated();
    return popupMenu.isVisible();
  }
}
</code></pre>

### 解説
上記のサンプルでは、`JMenu`を継承する`TransparentMenu`を作成して、自身と`JMenuItem`などを透明化し、`JMenu`から開く`JPopupMenu`は、[JPopupMenuを半透明にする](http://terai.xrea.jp/Swing/TranslucentPopupMenu.html)を使用して半透明にしています。

- [Translucent and Shaped Swing Windows | Java.net](http://today.java.net/pub/a/today/2008/03/18/translucent-and-shaped-swing-windows.html) を参考に `PopupFactory#getPopup(...)`をオーバーライドし、常に`JPopupMenu`(半透明)の親に`JWindow`(完全に透明、`Heavy weight`)を使用するように設定

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>PopupFactory.setSharedInstance(new TranslucentPopupFactory());
//...
class TranslucentPopupFactory extends PopupFactory {
  @Override public Popup getPopup(Component owner, Component contents, int x, int y)
                                                   throws IllegalArgumentException {
     return new TranslucentPopup(owner, contents, x, y);
   }
}
</code></pre>

- - - -
- [JPopupMenuを半透明にする](http://terai.xrea.jp/Swing/TranslucentPopupMenu.html)では、`JPopupMenu#show(...)`メソッドをオーバーライドし、ポップアップが親フレームからはみ出して `Heavy weight`の`JWindow`が`JPopupMenu`の親となる場合のみ、`JWindow#setBackground(ALPHA_ZERO)`などで透明化(`JPopupMenu`は半透明)
    - [Bug ID: 7156657 Version 7 doesn't support translucent popup menus against a translucent window](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=7156657) が原因？で、`1.7.0_06`以前では、サブメニューが半透明化されない場合がある
    - `PopupFactory.setSharedInstance(new TranslucentPopupFactory())`を使用する場合はバグの影響を受けない
    - 上記のバグ？以外にも、[JPopupMenuを半透明にする](http://terai.xrea.jp/Swing/TranslucentPopupMenu.html)でサブメニューを半透明にする場合、`Heavy weight`の`JPopupMenu`に使用する`JWindow`の`ContentPane`と`JRootPane`の不透明設定(`isOpaque()`)に注意する必要がある

<!-- dummy comment line for breaking list -->

	----
	HeavyWeightWindow: win0, JPopupMenu: base
	javax.swing.JPanel: false
	javax.swing.JLayeredPane: false
	javax.swing.JRootPane: false
	----
	HeavyWeightWindow: win1, JPopupMenu: sub
	javax.swing.JPanel: true
	javax.swing.JLayeredPane: false
	javax.swing.JRootPane: true

<pre class="prettyprint"><code>class TranslucentPopupMenu extends JPopupMenu {
  @Override public void show(Component c, int x, int y) {
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        Window p = SwingUtilities.getWindowAncestor(TranslucentPopupMenu.this);
        if(p!=null &amp;&amp; p instanceof JWindow) {
          JWindow w = (JWindow)p;
          w.setBackground(ALPHA_ZERO);
          System.out.format("HeavyWeightWindow: %s, JPopupMenu: %s\n", w.getName(), getName());
          Container c = (Container)w.getContentPane();
          while(c!=null &amp;&amp; c instanceof JComponent) {
            JComponent jc = (JComponent)c;
            System.out.format("%s: %s\n", c.getClass().getName(), jc.isOpaque());
            if(jc.isOpaque()) {
              jc.setOpaque(false);
            }
            c = c.getParent();
          }
        }else{
          System.out.println("Light weight");
        }
      }
    });
    super.show(c, x, y);
  }
  @Override protected void paintComponent(Graphics g) {
//...
</code></pre>

### 参考リンク
- [Translucent and Shaped Swing Windows | Java.net](http://today.java.net/pub/a/today/2008/03/18/translucent-and-shaped-swing-windows.html)
- [Bug ID: 7156657 Version 7 doesn't support translucent popup menus against a translucent window](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=7156657)
- [JPopupMenuを半透明にする](http://terai.xrea.jp/Swing/TranslucentPopupMenu.html)

<!-- dummy comment line for breaking list -->

### コメント
- [Java Bug Database](http://bugs.sun.com/bugdatabase/)の見た目が新しくなっている？ `Fixed Versions`の表示がシンプルになりすぎているような…。 -- [aterai](http://terai.xrea.jp/aterai.html) 2012-10-22 (月) 20:22:51

<!-- dummy comment line for breaking list -->

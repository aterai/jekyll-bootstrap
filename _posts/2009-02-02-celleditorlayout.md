---
layout: post
title: TableCellEditorのレイアウトを変更
category: swing
folder: CellEditorLayout
tags: [JTable, TableCellEditor, BorderLayout, JTextField, JButton, Focus, KeyboardFocusManager]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-02-02

## TableCellEditorのレイアウトを変更
`TableCellEditor`のレイアウトを変更して、`CellEditor`の隣に`JButton`を配置します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.ggpht.com/_9Z4BYR88imo/TQTIlcF-6vI/AAAAAAAAATA/mS6Q_BfuY6c/s800/CellEditorLayout.png)

### サンプルコード
<pre class="prettyprint"><code>class CustomComponentCellEditor extends DefaultCellEditor {
  protected final JTextField field;
  protected JButton button;
  private final JPanel panel = new JPanel(new BorderLayout());
  public CustomComponentCellEditor(JTextField field) {
    super(field);
    this.field = field;
    button = new JButton();
    button.setPreferredSize(new Dimension(25, 0));
    field.setBorder(BorderFactory.createEmptyBorder(0,2,0,0));
    panel.add(field);
    panel.add(button, BorderLayout.EAST);
    panel.setFocusable(false);
  }
  @Override public Component getTableCellEditorComponent(JTable table, Object value,
                         boolean isSelected, int row, int column) {
    //System.out.println("getTableCellEditorComponent");
    field.setText(value!=null?value.toString():"");
    EventQueue.invokeLater(new Runnable() {
      public void run() {
        field.requestFocusInWindow();
      }
    });
    return panel;
  }
  @Override public boolean isCellEditable(final java.util.EventObject e) {
    //System.out.println("isCellEditable");
    if(e instanceof KeyEvent) {
      //System.out.println("KeyEvent");
      EventQueue.invokeLater(new Runnable() {
        public void run() {
          char kc = ((KeyEvent)e).getKeyChar();
          if(!Character.isIdentifierIgnorable(kc)) {
            field.setText(field.getText()+kc);
          }
          field.setCaretPosition(field.getText().length());
          //field.requestFocusInWindow();
        }
      });
    }
    return super.isCellEditable(e);
  }
  @Override public Component getComponent() {
    return panel;
  }
}
</code></pre>

### 解説
- `0`列目
    - `DefaultCellEditor`を継承する`CustomComponentCellEditor`を作成
    - `JTextField`をコンストラクタの引数にしているが、ダミー
    - 実体は`JPanel`で、これをセルエディタとして表示(`TableCellEditor#getTableCellEditorComponent`が`JPanel`を返す)
    - この`JPanel`のレイアウトを`BorderLayout`にして、`JTextField`と`JButton`を配置
    - `TableCellEditor#getCellEditorValue`は`JTextField`の値を返し、フォーカス、キー入力時の編集開始なども`JTextField`になるように変更
    - 参考: [Swing - JTable editor issue](https://forums.oracle.com/thread/1354286):Darryl.Burke さんの投稿(2009/01/27 20:12 (reply 6 of 8))

<!-- dummy comment line for breaking list -->

- `1`列目
    - `DefaultCellEditor`を継承する`CustomCellEditor`を作成
    - `JTextField`をコンストラクタの引数(セルエディタの実体)として使用
    - `JTextField`に`JButton`の幅の右余白を設定
    - `JTextField`が表示されたときに、余白に`JButton`を`setBounds`で配置
    - 参考:[JTextField内にアイコンを追加](http://terai.xrea.jp/Swing/IconTextField.html)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>class CustomCellEditor extends DefaultCellEditor {
  private static final int BUTTON_WIDTH = 20;
  protected final JButton button = new JButton();
  public CustomCellEditor(final JTextField field) {
    super(field);
    field.setBorder(BorderFactory.createEmptyBorder(0,2,0,BUTTON_WIDTH));
    field.addHierarchyListener(new HierarchyListener() {
      public void hierarchyChanged(HierarchyEvent e) {
        if((e.getChangeFlags() &amp; HierarchyEvent.SHOWING_CHANGED)!=0
            &amp;&amp; field.isShowing()) {
          field.removeAll();
          field.add(button);
          Rectangle r = field.getBounds();
          button.setBounds(r.width-BUTTON_WIDTH, 0, BUTTON_WIDTH, r.height);
        }
      }
    });
  }
  @Override public Component getComponent() {
    //@see JTable#updateUI()
    SwingUtilities.updateComponentTreeUI(button);
    return super.getComponent();
  }
}
</code></pre>

- `2`列目
    - `DefaultCellEditor`を継承する`CustomComponentCellEditor2`を作成
    - `JTextField`をコンストラクタの引数にしているが、ダミー
    - 実体は`JPanel`を継承する`CustomComponent`で、これをセルエディタとして表示
    - `CustomComponent#processKeyBinding(...)`をオーバーライドして、キー入力開始時に`KeyboardFocusManager.getCurrentKeyboardFocusManager().redispatchEvent(field, e);`を呼び出している
    - あとは、`0`列目の`CustomComponentCellEditor`と同様

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>class CustomComponent extends JPanel {
  public final JTextField field = new JTextField();
  protected JButton button;
  public CustomComponent() {
    super(new BorderLayout(0,0));
    button = new JButton();
    this.add(field);
    this.add(button, BorderLayout.EAST);
  }
  @Override protected boolean processKeyBinding(
      final KeyStroke ks, final KeyEvent e, int condition, boolean pressed) {
    if(!field.isFocusOwner() &amp;&amp; !pressed) {
      field.requestFocusInWindow();
      SwingUtilities.invokeLater(new Runnable() {
        @Override public void run() {
          KeyboardFocusManager.getCurrentKeyboardFocusManager()
            .redispatchEvent(field, e);
        }
      });
    }
    return super.processKeyBinding(ks, e, condition, pressed);
  }
}
class CustomComponentCellEditor2 extends DefaultCellEditor {
  private final CustomComponent component;
  public CustomComponentCellEditor2(CustomComponent component) {
    super(component.field);
    this.component = component;
  }
  @Override public Component getTableCellEditorComponent(JTable table,
        Object value, boolean isSelected, int row, int column) {
    component.field.setText(value!=null?value.toString():"");
    return component;
  }
  @Override public Component getComponent() {
    return component;
  }
}
</code></pre>

- `3`列目
    - デフォルト

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Swing - JTable editor issue](https://forums.oracle.com/thread/1354286)
- [JTextField内にアイコンを追加](http://terai.xrea.jp/Swing/IconTextField.html)

<!-- dummy comment line for breaking list -->

### コメント
- <kbd>F2</kbd>で編集開始した場合、フォーカスできない問題を修正。 -- [aterai](http://terai.xrea.jp/aterai.html) 2009-08-10 (月) 15:50:27
- ソースコードだけ変更して、こちらのページの修正を忘れていたorzので、新しく追加した`2`列目の解説と、最終列はデフォルトであることを追記。スクリーンショットは面倒なので更新しない。 -- [aterai](http://terai.xrea.jp/aterai.html) 2011-08-30 (火) 18:26:59

<!-- dummy comment line for breaking list -->


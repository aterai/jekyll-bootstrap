---
layout: post
category: swing
folder: EditTabTitle
title: JTabbedPaneのタブタイトルを変更
tags: [JTabbedPane, GlassPane, JTextField]
author: aterai
pubdate: 2006-03-27T01:01:49+09:00
description: JTabbedPaneのタブタイトルを直接編集します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTMGR-jIQI/AAAAAAAAAYo/g3tGLp5zrdY/s800/EditTabTitle.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2008/09/double-click-on-each-tab-and-change-its.html
    lang: en
comments: true
---
## 概要
`JTabbedPane`のタブタイトルを直接編集します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTMGR-jIQI/AAAAAAAAAYo/g3tGLp5zrdY/s800/EditTabTitle.png %}

## サンプルコード
<pre class="prettyprint"><code>class EditableTabbedPane extends JTabbedPane {
  private final JComponent glassPane = new EditorGlassPane();
  private final JTextField editor = new JTextField();
  private final Action startEditing = new AbstractAction() {
    @Override public void actionPerformed(ActionEvent e) {
      getRootPane().setGlassPane(glassPane);
      Rectangle rect = getBoundsAt(getSelectedIndex());
      Point p = SwingUtilities.convertPoint(
          EditableTabbedPane.this, rect.getLocation(), glassPane);
      //rect.setBounds(p.x + 2, p.y + 2, rect.width - 4, rect.height - 4);
      rect.setLocation(p);
      rect.grow(-2, -2);
      editor.setBounds(rect);
      editor.setText(getTitleAt(getSelectedIndex()));
      editor.selectAll();
      glassPane.add(editor);
      glassPane.setVisible(true);
      editor.requestFocusInWindow();
    }
  };
  private final Action cancelEditing = new AbstractAction() {
    @Override public void actionPerformed(ActionEvent e) {
      glassPane.setVisible(false);
    }
  };
  private final Action renameTab = new AbstractAction() {
    @Override public void actionPerformed(ActionEvent e) {
      if (!editor.getText().trim().isEmpty()) {
        setTitleAt(getSelectedIndex(), editor.getText());
        //java 1.6.0 ----&gt;
        Component c = getTabComponentAt(getSelectedIndex());
        if (c instanceof JComponent) {
          ((JComponent) c).revalidate();
        }
        //&lt;----
      }
      glassPane.setVisible(false);
    }
  };
  protected EditableTabbedPane() {
    super();
    editor.setBorder(BorderFactory.createEmptyBorder(0, 3, 0, 3));
    editor.getInputMap(JComponent.WHEN_FOCUSED).put(
        KeyStroke.getKeyStroke(KeyEvent.VK_ENTER, 0), "rename-tab");
    editor.getActionMap().put("rename-tab", renameTab);
    editor.getInputMap(JComponent.WHEN_FOCUSED).put(
        KeyStroke.getKeyStroke(KeyEvent.VK_ESCAPE, 0), "cancel-editing");
    editor.getActionMap().put("cancel-editing", cancelEditing);

    addMouseListener(new MouseAdapter() {
      @Override public void mouseClicked(MouseEvent e) {
        if (e.getClickCount() == 2) {
          startEditing.actionPerformed(
            new ActionEvent(e.getComponent(), ActionEvent.ACTION_PERFORMED, ""));
        }
      }
    });
    getInputMap(JComponent.WHEN_FOCUSED).put(
        KeyStroke.getKeyStroke(KeyEvent.VK_ENTER, 0), "start-editing");
    getActionMap().put("start-editing", startEditing);
  }
  private class EditorGlassPane extends JComponent {
    protected EditorGlassPane() {
      super();
      setOpaque(false);
      setFocusTraversalPolicy(new DefaultFocusTraversalPolicy() {
        @Override public boolean accept(Component c) {
          return Objects.equals(c, editor);
        }
      });
      addMouseListener(new MouseAdapter() {
        @Override public void mouseClicked(MouseEvent e) {
          //if (Objects.nonNull(rect) &amp;&amp; !rect.contains(e.getPoint())) {
          if (!editor.getBounds().contains(e.getPoint())) {
            renameTab.actionPerformed(
              new ActionEvent(e.getComponent(), ActionEvent.ACTION_PERFORMED, ""));
          }
        }
      });
    }
    @Override public void setVisible(boolean flag) {
      super.setVisible(flag);
      setFocusTraversalPolicyProvider(flag);
      setFocusCycleRoot(flag);
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JTabbedPane`のタブタイトルを`Excel`などのように直接編集できるよう設定しています。

編集が開始されると、対象となるタブ上に`JTextField`をレイアウトした`GlassPane`を表示しています。この`GlassPane`には、編集中はフォーカスの移動が起こらないようにするための`FocusTraversalPolicy`などを追加しています。

- 操作方法
    - マウスでタブをダブルクリック、またはタブを選択して<kbd>Enter</kbd>キーで編集開始
    - 編集中に入力欄以外をクリック、または<kbd>Enter</kbd>キーでタイトル文字列が確定
    - 編集中は<kbd>Tab</kbd>キーを押しても無視
    - <kbd>Esc</kbd>キーで編集をキャンセル
    - `0`文字で確定した場合も、キャンセル扱い

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Cursorを砂時計に変更](https://ateraimemo.com/Swing/WaitCursor.html)
- [JTabbedPaneのタブにJTextFieldを配置してタイトルを編集](https://ateraimemo.com/Swing/TabTitleEditor.html)
    - `JDK 6`で追加された`JTabbedPane#setTabComponentAt`メソッドで、タブに`JTextField`を配置し、同様のことを行うサンプル
- [Swing - Floating text field](https://community.oracle.com/thread/1359811)
    - `JPopupMenu`に`JTextField`を配置することで、同様のことを行うコードをKelVarnsonさんが投稿している

<!-- dummy comment line for breaking list -->

## コメント
- `1.4`系だと編集開始時にうまく選択状態にできない場合があるようです。 -- *aterai* 2006-03-27 (月) 15:03:01
    - 上記の問題と、選択状態がマウスの移動で外れてしまうバグを修正しました。 -- *aterai* 2006-03-29 (水) 03:26:56
- 余白などを追加するとエディタがずれるバグを修正しました。 -- *aterai* 2006-09-01 (金) 15:04:00
- `setTabComponentAt(...)`メソッドで閉じるボタンなどと併用していた場合、編集後に文字列の長さがおかしくなるので、`revalidate()`するように修正。 -- *aterai* 2010-08-10 (火) 16:49:52

<!-- dummy comment line for breaking list -->
